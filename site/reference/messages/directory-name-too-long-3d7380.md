---
message: "directory name too long"
slug: directory-name-too-long-3d7380
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:332"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:476"
reproduced: false
---

# `directory name too long`

## What it means

A client tool built a target directory path that exceeded the platform's maximum length. It fires in `pg_basebackup`/`pg_combinebackup` when a constructed path is too long to use.

## When it happens

The output or tablespace-mapping path passed to the tool, combined with subdirectory names, exceeded the operating system's path-length limit.

## How to fix

Choose a shorter base path for the output or tablespace mapping. Reduce nesting so constructed paths stay within the platform limit.

## Example

*Illustrative* — a too-long backup target path.

```text
pg_basebackup: error: directory name too long
```

## Related

- [data directory does not exist](./data-directory-does-not-exist.md)
- [could not set permissions on directory](./could-not-set-permissions-on-directory.md)
