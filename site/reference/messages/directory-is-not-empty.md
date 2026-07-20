---
message: "directory \"%s\" is not empty"
slug: directory-is-not-empty
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/dumputils.c:966"
reproduced: false
---

# `directory "%s" is not empty`

## What it means

`pg_dump` was asked to write a directory-format archive to a directory that already contains files. The placeholder is implied by context. To avoid clobbering data, `pg_dump` refuses to write into a non-empty directory.

## When it happens

It fires from `pg_dump -Fd` (or a tool that creates an output directory) when the target directory exists and is not empty.

## How to fix

Choose a directory that does not yet exist or is empty, or remove the existing contents first. If you meant to overwrite a prior directory dump, delete it and rerun.

## Example

*Illustrative* — writing into a non-empty directory.

```text
pg_dump: error: directory "/backups/db" is not empty
```

## Related

- [directory does not appear to be a valid archive (toc.dat does not exist)](./directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist.md)
- [directory name too long](./directory-name-too-long-1e631c.md)
