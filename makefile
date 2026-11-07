SHELL              := $(shell which bash)

NO_COLOR           := \033[0m
OK_COLOR           := \033[32;01m
ERR_COLOR          := \033[31;01m
WARN_COLOR         := \033[36;01m
ATTN_COLOR         := \033[33;01m

GOOS               := $(shell go env GOOS)
GOARCH             := $(shell go env GOARCH)
GOPRIVATE          := "github.com/aserto-dev"

EXT_DIR            := ${PWD}/.ext
EXT_BIN_DIR        := ${EXT_DIR}/bin
EXT_TMP_DIR        := ${EXT_DIR}/tmp

TMP_DIR            := ${PWD}/.tmp
TMP_BUF_DIR        := ${TMP_DIR}/buf
TMP_OAI_DIR        := ${TMP_DIR}/openapi

GO_VER             := 1.27
SVU_VER            := 3.4.4
GOTESTSUM_VER      := 1.13.0
GOLANGCI-LINT_VER  := 2.15.0
GORELEASER_VER     := 2.20.0
BUF_VER            := 1.75.0
MERGE-JSON_VER     := 0.2.0
GOFUMPT_VER        := latest

PROJECT            := authorizer
PROTO_REPO         := go-${PROJECT}
BUF_REPO           := buf.build/aserto-dev/${PROJECT}
BUF_LATEST         := $(shell ${EXT_BIN_DIR}/buf registry module label list ${BUF_REPO} --format json | jq -r '.labels[0].name')
BUF_DEV_IMAGE      := ${TMP_BUF_DIR}/${PROJECT}.bin

RELEASE_TAG        := $$(${EXT_BIN_DIR}/svu current)
NEXT_TAG           := $$(${EXT_BIN_DIR}/svu patch)

.DEFAULT_GOAL      := build

.PHONY: build
build: gover buf-build buf-lint buf-generate-dev go-mod-tidy lint test
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"

.PHONY: deps
deps: info install-buf install-svu install-golangci-lint install-gotestsum install-merge-json install-gofumpt
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"

.PHONY: gover
gover:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@(go env GOVERSION | grep "go${GO_VER}") || (echo "go version check failed expected go${GO_VER} got $$(go env GOVERSION)"; exit 1)

PHONY: go-fmt
go-fmt: 
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/gofumpt -l -w .

PHONY: go-mod-tidy
go-mod-tidy: go-fmt go-work-sync
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@exit_code=0; \
	modules=$$(go work edit -json | jq -r '.Use[].DiskPath // empty'); \
	for mod in $$modules; do \
		if [ "$$mod" = "." ]; then \
			mod_dir=$$(pwd); \
		else \
			mod_dir=$$(realpath "$$mod" 2>/dev/null || echo "$$mod"); \
		fi; \
		echo -e "$(ATTN_COLOR)==> $@ $$mod_dir$(NO_COLOR)"; \
		(cd "$$mod_dir" && go mod tidy) || exit_code=$$?; \
	done; \
	exit $$exit_code

PHONY: go-work-sync
go-work-sync:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@go work sync

.PHONY: lint
lint: gover
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/golangci-lint config path
	@${EXT_BIN_DIR}/golangci-lint config verify
	@exit_code=0; \
	config=${PWD}/.golangci.yaml; \
	modules=$$(go work edit -json | jq -r '.Use[].DiskPath // empty'); \
	for mod in $$modules; do \
		if [ "$$mod" = "." ]; then \
			mod_dir=$$(pwd); \
		else \
			mod_dir=$$(realpath "$$mod" 2>/dev/null || echo "$$mod"); \
		fi; \
		echo -e "$(ATTN_COLOR)==> $@ $$mod_dir$(NO_COLOR)"; \
		(cd "$$mod_dir" && ${EXT_BIN_DIR}/golangci-lint run --config $$config ./...) || exit_code=$$?; \
	done; \
	exit $$exit_code

.PHONY: lint-clean
lint-clean: gover
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/golangci-lint cache clean

.PHONY: test
test: gover
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@exit_code=0; \
	modules=$$(go work edit -json | jq -r '.Use[].DiskPath // empty'); \
	for mod in $$modules; do \
		if [ "$$mod" = "." ]; then \
			mod_dir=$$(pwd); \
		else \
			mod_dir=$$(realpath "$$mod" 2>/dev/null || echo "$$mod"); \
		fi; \
		echo -e "$(ATTN_COLOR)==> $@ $$mod_dir$(NO_COLOR)"; \
		(cd "$$mod_dir" && ${EXT_BIN_DIR}/gotestsum --format short-verbose -- -count=1 -v ./... -coverprofile=cover.out -coverpkg=./... ./...) || exit_code=$$?; \
	done; \
	exit $$exit_code

.PHONY: buf-login
buf-login:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@echo ${BUF_TOKEN} | ${EXT_BIN_DIR}/buf registry login --token-stdin

.PHONY: buf-dep-update
buf-dep-update:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf dep update

.PHONY: buf-format
buf-format:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf format -w proto

.PHONY: buf-build
buf-build: ${TMP_BUF_DIR} buf-format 
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf build --output ${BUF_DEV_IMAGE}

.PHONY: buf-lint
buf-lint:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf lint

.PHONY: buf-breaking
buf-breaking:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf breaking --against "github.com/aserto-dev/pb-authorizer.git#branch=main"

.PHONY: buf-push
buf-push:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/buf push --label ${RELEASE_TAG}

.PHONY: buf-generate
buf-generate: buf-clean generate merge-json
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"

.PHONY: buf-generate-dev
buf-generate-dev: ${BUF_DEV_IMAGE} buf-clean generate-dev merge-json
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"

generate:
	@echo -e "$(ATTN_COLOR)==> $@ ${BUF_REPO}:${BUF_LATEST}$(NO_COLOR)"
	@${EXT_BIN_DIR}/buf generate ${BUF_REPO}:${BUF_LATEST}

generate-dev: ${TMP_BUF_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ ${BUF_DEV_IMAGE}$(NO_COLOR)"
	@${EXT_BIN_DIR}/buf generate ${BUF_DEV_IMAGE}

.PHONY: merge-json
merge-json:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/merge-json -output ./openapi/authorizer.openapi.json \
	.tmp/openapi/aserto/authorizer/v2/authorizer.openapi.json

.PHONY: buf-clean
buf-clean:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@rm -rf ./aserto/authorizer

.PHONY: info
info:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@echo "PROJECT:       ${PROJECT}"
	@echo "PROTO_REPO:    ${PROTO_REPO}"
	@echo "GOOS:          ${GOOS}"
	@echo "GOARCH:        ${GOARCH}"
	@echo "EXT_BIN_DIR:   ${EXT_BIN_DIR}"
	@echo "EXT_TMP_DIR:   ${EXT_TMP_DIR}"
	@echo "EXT_BIN_DIR:   ${EXT_BIN_DIR}"
	@echo "TMP_BUF_DIR:   ${TMP_BUF_DIR}"
	@echo "TMP_OAI_DIR:   ${TMP_OAI_DIR}"
	@echo "BUF_REPO:      ${BUF_REPO}"
	@echo "BUF_LATEST:    ${BUF_LATEST}"
	@echo "BUF_DEV_IMAGE: ${BUF_DEV_IMAGE}"
	@echo "RELEASE_TAG:   ${RELEASE_TAG}"
	@echo "NEXT_TAG:      ${NEXT_TAG}"
	
.PHONY: install-buf
install-buf: ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	GOBIN=${EXT_BIN_DIR} go install github.com/bufbuild/buf/cmd/buf@v${BUF_VER}
	@${EXT_BIN_DIR}/buf --version

.PHONY: install-svu
install-svu: ${EXT_BIN_DIR} ${EXT_TMP_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@GOBIN=${EXT_BIN_DIR} go install github.com/caarlos0/svu/v3@v${SVU_VER}
	@${EXT_BIN_DIR}/svu --version

.PHONY: install-gotestsum
install-gotestsum: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${GOTESTSUM_VER} --repo https://github.com/gotestyourself/gotestsum --pattern "gotestsum_${GOTESTSUM_VER}_${GOOS}_${GOARCH}.tar.gz" --output "${EXT_TMP_DIR}/gotestsum.tar.gz" --clobber
	@tar -xvf ${EXT_TMP_DIR}/gotestsum.tar.gz --directory ${EXT_BIN_DIR} gotestsum &> /dev/null
	@chmod +x ${EXT_BIN_DIR}/gotestsum
	@${EXT_BIN_DIR}/gotestsum --version

.PHONY: install-golangci-lint
install-golangci-lint: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${GOLANGCI-LINT_VER} --repo https://github.com/golangci/golangci-lint --pattern "golangci-lint-${GOLANGCI-LINT_VER}-${GOOS}-${GOARCH}.tar.gz" --output "${EXT_TMP_DIR}/golangci-lint.tar.gz" --clobber
	@tar --strip=1 -xvf ${EXT_TMP_DIR}/golangci-lint.tar.gz --strip-components=1 --directory ${EXT_TMP_DIR} &> /dev/null
	@mv ${EXT_TMP_DIR}/golangci-lint ${EXT_BIN_DIR}/golangci-lint
	@chmod +x ${EXT_BIN_DIR}/golangci-lint
	@${EXT_BIN_DIR}/golangci-lint --version

.PHONY: install-goreleaser
install-goreleaser: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${GORELEASER_VER} --repo https://github.com/goreleaser/goreleaser --pattern "goreleaser_$$(uname -s)_$$(uname -m).tar.gz" --output "${EXT_TMP_DIR}/goreleaser.tar.gz" --clobber
	@tar -xvf ${EXT_TMP_DIR}/goreleaser.tar.gz --directory ${EXT_BIN_DIR} goreleaser &> /dev/null
	@chmod +x ${EXT_BIN_DIR}/goreleaser
	@${EXT_BIN_DIR}/goreleaser --version

.PHONY: install-gofumpt
install-gofumpt: ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@GOBIN=${EXT_BIN_DIR} go install mvdan.cc/gofumpt@${GOFUMPT_VER}

.PHONY: install-merge-json
install-merge-json: ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@GOBIN=${EXT_BIN_DIR} go install github.com/topaz-io/merge-json@v${MERGE-JSON_VER}

.PHONY: clean
clean:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@rm -rf ${EXT_DIR}
	@rm -rf ${TMP_DIR}

${EXT_BIN_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${EXT_BIN_DIR}

${EXT_TMP_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${EXT_TMP_DIR}

${TMP_BUF_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${TMP_BUF_DIR}

${TMP_OAI_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${TMP_OAI_DIR}

MODULES := aserto openapi pkg

.PHONY: tag-release
tag-release:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@if [ -z "$(TAG)" ]; then \
		echo "Error: TAG is not set. Run with: make tag-release TAG=v0.1.23"; \
		exit 1; \
	fi
	git tag -f $(TAG)
	@for mod in $(MODULES); do \
		echo "tag $$mod/$(TAG)..."; \
		git tag -f $$mod/$(TAG); \
	done
	@echo "push tags to origin..."
	git push origin "*/$(TAG)" --force
