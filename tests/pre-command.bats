#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export AWS_STUB_DEBUG=/dev/tty

@test "Syncs files from the source directory to the destination S3 bucket" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=destination/

  stub aws "s3 sync s3://source destination/ : echo s3 sync"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "s3 sync"
  unstub aws
}

@test "Syncs and deletes files" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=destination/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DELETE=true

  stub aws "s3 sync --delete s3://source destination/ : echo s3 sync --delete"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "s3 sync --delete"
  unstub aws
}

@test "Doesn't follow symlinks" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=destination/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_FOLLOW_SYMLINKS=false

  stub aws "s3 sync --no-follow-symlinks s3://source destination/ : echo s3 sync --no-follow-symlinks"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "s3 sync --no-follow-symlinks"
  unstub aws
}

@test "Uses endpoint URL" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=destination/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_ENDPOINT_URL=envato-test-bucket.s3-website-us-east-1.amazonaws.com

  stub aws "s3 sync --endpoint-url=envato-test-bucket.s3-website-us-east-1.amazonaws.com s3://source destination/ : echo s3 sync --endpoint-url=envato-test-bucket.s3-website-us-east-1.amazonaws.com"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "s3 sync --endpoint-url=envato-test-bucket.s3-website-us-east-1.amazonaws.com"
  unstub aws
}

@test "Ignores cache control option" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=destination/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL="public,max-age=315360000"

  stub aws "s3 sync s3://source destination/ : echo s3 sync"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "s3 sync"
  unstub aws
}

@test "Skips pre command when source is local" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  run $PWD/hooks/pre-command

  assert_success
}

@test "Skips pre command when source and destination are both s3" {
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=s3://source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  run $PWD/hooks/pre-command

  assert_success
}
