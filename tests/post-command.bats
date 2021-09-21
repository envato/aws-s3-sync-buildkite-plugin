#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export AWS_STUB_DEBUG=/dev/tty

@test "Syncs files from the source directory to the destination S3 bucket" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  stub aws "s3 sync source/ s3://destination : echo s3 sync"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "s3 sync"
  unstub aws
}

@test "Syncs files from the source directory to the destination S3 bucket with delete" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DELETE=true

  stub aws "s3 sync --delete source/ s3://destination : echo s3 sync --delete"

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "s3 sync --delete"
  unstub aws
}

@test "Doesn't attempt to sync files if the step command fails" {
  export BUILDKITE_COMMAND_EXIT_STATUS=1
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  run $PWD/hooks/post-command

  assert_success
}
