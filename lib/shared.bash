#!/bin/bash

function aws_s3_sync() {
  local source=$1
  local destination=$2

  params=()

  if [[ "${BUILDKITE_PLUGIN_AWS_S3_SYNC_DELETE:-false}" == "true" ]]; then
    params+=(--delete)
  fi

  if [[ "${BUILDKITE_PLUGIN_AWS_S3_SYNC_FOLLOW_SYMLINKS:-true}" == "false" ]]; then
    params+=(--no-follow-symlinks)
  fi

  if [[ -n "${BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL:-}" ]]; then
    params+=("--cache-control ${BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL}")
  fi

  params+=("$source")
  params+=("$destination")

  echo "~~~ :s3: Syncing $source to $destination"
  aws s3 sync "${params[@]}"
}
