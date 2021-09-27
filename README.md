# AWS S3 Sync Buildkite Plugin

![Build status](https://badge.buildkite.com/39a2058c81ac115411ffaa5f902b15c5c6afd425ce2194c371.svg?branch=main)
[![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

A [Buildkite plugin] that syncs files to the AWS Simple Storage Service (S3).

## Example

Sync files after the command with s3 (`post-command` hook)

```yml
steps:
  - label: "Generate files and push to S3"
    command: bin/command-that-generates-files
    plugins:
      - envato/aws-s3-sync#v0.2.0:
          source: local-directory/
          destination: s3://example-bucket/directory/
```

When the source is s3, it will sync files before the command (`pre-command` hook)

```yml
steps:
  - label: "Pull files from S3 and execute task"
    command: bin/command-that-uses-files
    plugins:
      - envato/aws-s3-sync#v0.2.0:
          source: s3://example-bucket/directory/
          destination: local-directory/
```

## Configuration

### `source`

The source directory containing the files to sync to S3.

### `destination`

The S3 URI describing where to sync the files to.

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
