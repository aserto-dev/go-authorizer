SHELL           := $(shell which bash)

NO_COLOR        := \033[0m
OK_COLOR        := \033[32;01m
ERR_COLOR       := \033[31;01m
WARN_COLOR      := \033[36;01m
ATTN_COLOR      := \033[33;01m

GOOS            := $(shell go env GOOS)
GOARCH          := $(shell go env GOARCH)
GOPRIVATE       := "github.com/aserto-dev"

BIN_DIR         := ./bin
EXT_DIR         := ./.ext
EXT_BIN_DIR     := ${EXT_DIR}/bin
EXT_TMP_DIR     := ${EXT_DIR}/tmp

VAULT_VERSION   := 1.8.12
SVU_VERSION     := 1.12.0
BUF_VERSION     := 1.34.0
GOTESTSUM_VERSION := 1.11.0
GOLANGCI-LINT_VERSION := 1.61.0

PROJECT         := authorizer
BUF_USER        := $(shell vault kv get -field ASERTO_BUF_USER kv/buf.build)
BUF_TOKEN       := $(shell vault kv get -field ASERTO_BUF_TOKEN kv/buf.build)
BUF_REPO        := "buf.build/aserto-dev/${PROJECT}"
BUF_LATEST      := $(shell BUF_BETA_SUPPRESS_WARNINGS=1 ${EXT_BIN_DIR}/buf beta registry label list ${BUF_REPO} --format json --reverse | jq -r '.results[0].name')
BUF_DEV_IMAGE   := "${PROJECT}.bin"
PROTO_REPO      := "pb-${PROJECT}"

GIT_ORG         := "https://github.com/aserto-dev"

RELEASE_TAG	    := $$(svu)

.PHONY: deps
deps: info install-vault install-buf install-svu install-golangci-lint install-gotestsum
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"

lint:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/golangci-lint run --config ${PWD}/.golangci.yaml

test:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@${EXT_BIN_DIR}/gotestsum --format short-verbose -- -count=1 -v ${PWD}/... -coverprofile=cover.out -coverpkg=./... ${PWD}/...

.PHONY: vault-login
vault-login:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@vault login -method=github token=$$(gh auth token)

.PHONY: buf-login
buf-login:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@echo ${BUF_TOKEN} | ${EXT_BIN_DIR}/buf registry login --username ${BUF_USER} --token-stdin

.PHONY: buf-generate
buf-generate:
	@echo -e "$(ATTN_COLOR)==> $@ ${BUF_REPO}:${BUF_LATEST}$(NO_COLOR)"
	@${EXT_BIN_DIR}/buf generate ${BUF_REPO}:${BUF_LATEST}

.PHONY: buf-generate-dev
buf-generate-dev:
	@echo -e "$(ATTN_COLOR)==> $@ ../${PROTO_REPO}/bin/${BUF_DEV_IMAGE}$(NO_COLOR)"
	@${EXT_BIN_DIR}/buf generate "../${PROTO_REPO}/bin/${BUF_DEV_IMAGE}"

.PHONY: info
info:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@echo "PROJECT:       ${PROJECT}"
	@echo "GOOS:          ${GOOS}"
	@echo "GOARCH:        ${GOARCH}"
	@echo "BIN_DIR:       ${BIN_DIR}"
	@echo "EXT_DIR:       ${EXT_DIR}"
	@echo "EXT_BIN_DIR:   ${EXT_BIN_DIR}"
	@echo "EXT_TMP_DIR:   ${EXT_TMP_DIR}"
	@echo "RELEASE_TAG:   ${RELEASE_TAG}"
	@echo "BUF_REPO:      ${BUF_REPO}"
	@echo "BUF_LATEST:    ${BUF_LATEST}"
	@echo "BUF_DEV_IMAGE: ${BUF_DEV_IMAGE}"
	@echo "PROTO_REPO:    ${PROTO_REPO}"

.PHONY: install-vault
install-vault: ${EXT_BIN_DIR} ${EXT_TMP_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@curl -s -o ${EXT_TMP_DIR}/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${GOOS}_${GOARCH}.zip
	@unzip -o ${EXT_TMP_DIR}/vault.zip vault -d ${EXT_BIN_DIR}/  &> /dev/null
	@chmod +x ${EXT_BIN_DIR}/vault
	@${EXT_BIN_DIR}/vault --version

.PHONY: install-buf
install-buf: ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${BUF_VERSION} --repo https://github.com/bufbuild/buf --pattern "buf-$$(uname -s)-$$(uname -m)" --output "${EXT_BIN_DIR}/buf" --clobber
	@chmod +x ${EXT_BIN_DIR}/buf
	@${EXT_BIN_DIR}/buf --version

.PHONY: install-svu
install-svu: install-svu-${GOOS}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@chmod +x ${EXT_BIN_DIR}/svu
	@${EXT_BIN_DIR}/svu --version

.PHONY: install-svu-darwin
install-svu-darwin: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download --repo https://github.com/caarlos0/svu --pattern "svu_*_darwin_all.tar.gz" --output "${EXT_TMP_DIR}/svu.tar.gz" --clobber
	@tar -xvf ${EXT_TMP_DIR}/svu.tar.gz --directory ${EXT_BIN_DIR} svu &> /dev/null

.PHONY: install-svu-linux
install-svu-linux: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download --repo https://github.com/caarlos0/svu --pattern "svu_*_linux_${GOARCH}.tar.gz" --output "${EXT_TMP_DIR}/svu.tar.gz" --clobber
	@tar -xvf ${EXT_TMP_DIR}/svu.tar.gz --directory ${EXT_BIN_DIR} svu &> /dev/null

.PHONY: install-gotestsum
install-gotestsum: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${GOTESTSUM_VERSION} --repo https://github.com/gotestyourself/gotestsum --pattern "gotestsum_${GOTESTSUM_VERSION}_${GOOS}_${GOARCH}.tar.gz" --output "${EXT_TMP_DIR}/gotestsum.tar.gz" --clobber
	@tar -xvf ${EXT_TMP_DIR}/gotestsum.tar.gz --directory ${EXT_BIN_DIR} gotestsum &> /dev/null
	@chmod +x ${EXT_BIN_DIR}/gotestsum
	@${EXT_BIN_DIR}/gotestsum --version

.PHONY: install-golangci-lint
install-golangci-lint: ${EXT_TMP_DIR} ${EXT_BIN_DIR}
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@gh release download v${GOLANGCI-LINT_VERSION} --repo https://github.com/golangci/golangci-lint --pattern "golangci-lint-${GOLANGCI-LINT_VERSION}-${GOOS}-${GOARCH}.tar.gz" --output "${EXT_TMP_DIR}/golangci-lint.tar.gz" --clobber
	@tar --strip=1 -xvf ${EXT_TMP_DIR}/golangci-lint.tar.gz --strip-components=1 --directory ${EXT_TMP_DIR} &> /dev/null
	@mv ${EXT_TMP_DIR}/golangci-lint ${EXT_BIN_DIR}/golangci-lint
	@chmod +x ${EXT_BIN_DIR}/golangci-lint
	@${EXT_BIN_DIR}/golangci-lint --version

.PHONY: clean
clean:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@rm -rf ./.ext
	@rm -rf ./bin

.PHONY: clean-gen
clean-gen:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@rm -rf ./aserto

${BIN_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${BIN_DIR}

${EXT_BIN_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${EXT_BIN_DIR}

${EXT_TMP_DIR}:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@mkdir -p ${EXT_TMP_DIR}
