---
message: "directory name too long: \"%s\""
slug: directory-name-too-long-1e631c
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2243"
reproduced: false
---

# `directory name too long: "%s"`

## What it means

`pg_dump`/`pg_restore` built a file path inside a directory-format archive that exceeded the platform's maximum path length. The placeholder is the offending name.

## When it happens

It fires while a directory-format archive is written or read and a member file's full path is longer than the operating system allows.

## How to fix

Use a shorter output directory path so the per-object file names fit within the platform limit. Moving the archive directory closer to the filesystem root usually resolves it.

## Example

*Illustrative* — an over-long archive member path.

```text
pg_dump: error: directory name too long: "/very/long/path/..."
```

## Related

- [directory is not empty](./directory-is-not-empty.md)
- [directory does not appear to be a valid archive (toc.dat does not exist)](./directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist.md)
