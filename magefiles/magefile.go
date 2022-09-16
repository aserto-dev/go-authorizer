//go:build mage

package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"strings"

	"github.com/aserto-dev/clui"
	"github.com/aserto-dev/go-utils/fsutil"
	"github.com/aserto-dev/mage-loot/buf"
	"github.com/aserto-dev/mage-loot/deps"
	"github.com/aserto-dev/mage-loot/mage"
	"github.com/aserto-dev/mage-loot/testutil"
	"github.com/magefile/mage/mg"
)

var (
	ui = clui.NewUI()
)

func init() {
	os.Setenv("GO_VERSION", "1.17")
	os.Setenv("GOPRIVATE", "github.com/aserto-dev")
}

// install all required dependencies.
func Deps() {
	deps.GetAllDeps()
}

// execute all targets in dependency order.
// deps, build, lint,
func All() error {
	mg.SerialDeps(Deps)

	return nil
}

// Builds the aserto proto image
func BuildDev() error {
	return mage.RunDirs(path.Join(getProtoRepo(), "magefiles"), getProtoRepo(), mage.AddArg("build"))
}

// Generates from a dev build.
func GenerateDev() error {
	err := BuildDev()
	if err != nil {
		return err
	}

	bufImage := filepath.Join(getProtoRepo(), "bin", "authorizer.bin#format=bin")
	fileSources := filepath.Join(getProtoRepo(), "proto#format=dir")

	return gen(bufImage, fileSources)
}

func getProtoRepo() string {
	protoRepo := os.Getenv("PROTO_REPO")
	if protoRepo == "" {
		protoRepo = "../pb-authorizer"
	}
	return protoRepo
}

// Generate Go bindings for Authorizer
func Generate() error {
	bufImage := "buf.build/aserto-dev/authorizer"

	os.Setenv("BUF_BETA_SUPPRESS_WARNINGS", "1")

	tag, err := buf.GetLatestTag(bufImage)
	if err != nil {
		fmt.Println("Could not retrieve tags, using latest")
	} else {
		bufImage = fmt.Sprintf("%s:%s", bufImage, tag.Name)
	}

	if err := gen(bufImage, bufImage); err != nil {
		return err
	}

	return nil
}

// Removes generated files
func Clean() error {
	return os.RemoveAll("aserto")
}

func gen(bufImage, fileSources string) error {

	files, err := getClientFiles(fileSources)
	if err != nil {
		return err
	}

	oldPath := os.Getenv("PATH")

	pathSeparator := string(os.PathListSeparator)
	path := oldPath +
		pathSeparator +
		filepath.Dir(deps.GoBinPath("protoc-gen-go-grpc")) +
		pathSeparator +
		filepath.Dir(deps.GoBinPath("protoc-gen-grpc-gateway")) +
		pathSeparator +
		filepath.Dir(deps.GoBinPath("protoc-gen-go"))

	return buf.RunWithEnv(map[string]string{
		"PATH": path,
	},
		buf.AddArg("generate"),
		buf.AddArg("--template"),
		buf.AddArg("buf.gen.yaml"),
		buf.AddArg(bufImage),
		buf.AddPaths(files),
	)
}

func getClientFiles(fileSources string) ([]string, error) {
	var clientFiles []string

	bufExportDir, err := ioutil.TempDir("", "bufimage")
	if err != nil {
		return clientFiles, err
	}
	bufExportDir = filepath.Join(bufExportDir, "")

	defer os.RemoveAll(bufExportDir)
	err = buf.Run(
		buf.AddArg("export"),
		buf.AddArg(fileSources),
		buf.AddArg("--exclude-imports"),
		buf.AddArg("-o"),
		buf.AddArg(bufExportDir),
	)
	if err != nil {
		return clientFiles, err
	}
	//excludePattern := filepath.Join(bufExportDir, "aserto", "authorizer", "authorizer", "**", "*.proto")

	protoFiles, err := fsutil.Glob(filepath.Join(bufExportDir, "aserto", "**", "*.proto"), "")
	if err != nil {
		return clientFiles, err
	}

	for _, protoFile := range protoFiles {
		clientFiles = append(clientFiles, strings.TrimPrefix(protoFile, bufExportDir+string(filepath.Separator)))
	}

	return clientFiles, nil
}

func bufModUpdate(dir string) error {
	return buf.Run(
		buf.AddArg("mod"),
		buf.AddArg("update"),
		buf.AddArg(dir),
	)
}

func bufLogin() error {
	bufToken := testutil.VaultValue("buf.build", "ASERTO_BUF_TOKEN")
	bufUser := testutil.VaultValue("buf.build", "ASERTO_BUF_USER")

	args := []string{"registry", "login", "--username", bufUser, "--token-stdin"}

	cmd := exec.Command(deps.GoBinPath("buf"), args...)
	stdin, err := cmd.StdinPipe()
	if err != nil {
		return err
	}

	go func() {
		defer stdin.Close()
		io.WriteString(stdin, bufToken)
	}()

	out, err := cmd.CombinedOutput()
	if err != nil {
		return err
	}

	ui.Normal().
		Msg(">>> executing buf " + strings.Join(args, " "))
	ui.Normal().
		Msg(string(out))

	return err
}

func getLocalTag() (string, error) {
	svu := deps.GoDepOutput("svu")

	out, err := svu()
	if err != nil {
		fmt.Println(out)
		return "", err
	}
	return out, nil
}
