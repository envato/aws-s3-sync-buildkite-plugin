# AWS S3 Sync Buildkite Plugin

![Build status](https://badge.buildkite.com/39a2058c81ac115411ffaa5f902b15c5c6afd425ce2194c371.svg?branch=main)
[![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

A [Buildkite plugin] that syncs files to the AWS Simple Storage Service (S3).

## Example

```yml
steps:
  - label: "Generate files and push to S3"
    command: bin/command-that-generates-files
    plugins:
      - envato/aws-s3-sync#v0.1.0:
          source: local-directory/
          destination: s3://example-bucket/directory/
```

## Configuration

### `source`

The source directory containing the files to sync to S3.

### `destination`

The S3 URI describing where to sync the files to.

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
