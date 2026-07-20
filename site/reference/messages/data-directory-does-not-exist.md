---
message: "data directory \"%s\" does not exist"
slug: data-directory-does-not-exist
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:306"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:461"
reproduced: false
---

# `data directory "%s" does not exist`

## What it means

A data directory named in configuration or on the command line does not exist. The `%s` is the path. On the server this is `data_directory`; in a client tool it is a target that must already exist.

## When it happens

The server was started with a `-D`/`data_directory` that is wrong or unmounted, or a tool (for example `pg_createsubscriber`) was pointed at a nonexistent data directory.

## How to fix

Correct the path to an existing, initialized data directory, and ensure the filesystem is mounted. For a new cluster, run `initdb` first.

## Example

*Illustrative* — the configured data directory is missing.

```text
FATAL:  data directory "/var/lib/pgsql/data" does not exist
```

## Related

- [could not locate my own executable path](./could-not-locate-my-own-executable-path.md)
- [directory name too long](./directory-name-too-long-3d7380.md)
