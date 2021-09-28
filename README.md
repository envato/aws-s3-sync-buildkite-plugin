# AWS S3 Sync Buildkite Plugin

![Build status](https://badge.buildkite.com/39a2058c81ac115411ffaa5f902b15c5c6afd425ce2194c371.svg?branch=main)
[![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

A [Buildkite plugin] that syncs files to the AWS Simple Storage Service (S3). It automatically detects when the local path is the source or destination, then syncs after or before the step `command` respectively.

## Example

Sync local files source with s3 destination. This is run after the main command in a [`post-command` job hook](https://buildkite.com/docs/agent/v3/hooks#job-lifecycle-hooks).

```yml
steps:
  - label: "Generate files and push to S3"
    command: bin/command-that-generates-files
    plugins:
      - envato/aws-s3-sync#v0.3.0:
          source: local-directory/
          destination: s3://example-bucket/directory/
```

Sync s3 files source with a local path destination. This is run before the main command in a [`pre-command` job hook](https://buildkite.com/docs/agent/v3/hooks#job-lifecycle-hooks).

```yml
steps:
  - label: "Pull files from S3 and execute task"
    command: bin/command-that-uses-files
    plugins:
      - envato/aws-s3-sync#v0.3.0:
          source: s3://example-bucket/directory/
          destination: local-directory/
```

Syncing s3 files source with a s3 files destination. This is run after the main command in a [`post-command` job hook](https://buildkite.com/docs/agent/v3/hooks#job-lifecycle-hooks).

````yml
steps:
  - label: "Copy between buckets"
    plugins:
      - envato/no-command#v0.1.0: ~
      - envato/aws-s3-sync#v0.3.0:
          source: s3://example-bucket/directory/
          destination: s3://other-bucket/directory/

## Configuration

### `source`

The source location containing the local path or the s3 uri.

### `destination`

The destination location containing the local path or the s3 uri.

### `delete`

Defaults to `false`

Files that exist in the destination but not in the source are deleted during sync.

### `follow-symlinks`

Defaults to `true`

Symbolic links are followed only when uploading to S3 from the local filesystem.

## Development

To run the tests:

```sh
docker-compose run --rm tests
```

To run the [Buildkite Plugin Linter]:

```sh
docker-compose run --rm lint
```

[Buildkite plugin]: https://buildkite.com/docs/agent/v3/plugins
[Buildkite Plugin Linter]: https://github.com/buildkite-plugins/buildkite-plugin-linter
