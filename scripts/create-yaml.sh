#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)
CHART_DIR=$(cd "${MODULE_DIR}/chart/cluster-config"; pwd -P)

NAME="$1"
DEST_DIR="$2"
VALUES_FILE="$3"
export GITOPS_URL="$4"

mkdir -p "${DEST_DIR}"

YQ=$(command -v "${BIN_DIR}/yq4")

cp -R "${CHART_DIR}"/* "${DEST_DIR}"

if [[ -n "${GITOPS_URL}" ]] && [[ -n "${YQ}" ]]; then
  ${YQ} eval '.gitops.url = env(GITOPS_URL)' "${CHART_DIR}/values.yaml" > "${DEST_DIR}/values.yaml"
elif [[ -z "${YQ}" ]]; then
  echo "YQ cli not found"
fi

if [[ -n "${VALUES_FILE}" ]] && [[ -n "${VALUES_CONTENT}" ]]; then
  echo "${VALUES_CONTENT}" > "${DEST_DIR}/${VALUES_FILE}"
fi

find "${DEST_DIR}" -name "*"
