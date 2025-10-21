#!/usr/bin/env bash

#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

set -euf -o pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 module_path"
  exit 2
fi

TCI_JSON=$(terraform-config-inspect --json "$1")

while read vc
do
  if ! grep '~>' <<< "$vc" > /dev/null
  then
    echo "version constraint must use ~> operator"
    exit 1
  fi
done <<< $(jq -r '.required_providers.apstra.version_constraints[]' <<< "$TCI_JSON")

PROVIDER_CONFIGS=$(jq .'provider_configs' <<< "$TCI_JSON")

if [ "$PROVIDER_CONFIGS" != "null" ]; then
  echo "provider block found in $1"
  exit 3
fi

jq -r '[.module_calls[] .source] | .[]' <<< "$TCI_JSON" | while read DIR
do
  DIR="${1}/${DIR}"
  if ! "$0" "$DIR"; then
    exit 4
  fi
done
