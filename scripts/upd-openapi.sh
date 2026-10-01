#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

printf 'convert *.swagger.json => *.openapi.json\n'

for FILENAME in $(find . -name '*.swagger.json'); do \
   echo "${FILENAME} => ${FILENAME//swagger/openapi}"; \
  .ext/bin/openapi-spec-converter -t 3.1 -f json -o "${FILENAME//swagger/openapi}" ${FILENAME};\
  rm -f ${FILENAME}
done

printf '\n'

mkdir -p ./openapi

.ext/bin/merge-json -output ./openapi/authorizer.openapi.json \
./tmp/aserto/authorizer/v2/authorizer.openapi.json \
./tmp/aserto/authorizer/v2/api/decision_logs.openapi.json \
./tmp/aserto/authorizer/v2/api/identity_context.openapi.json \
./tmp/aserto/authorizer/v2/api/module.openapi.json \
./tmp/aserto/authorizer/v2/api/policy_context.openapi.json \
./tmp/aserto/authorizer/v2/api/policy_instance.openapi.json

rm -rf ./tmp
