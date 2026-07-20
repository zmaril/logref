---
message: "%s: cannot copy from/to a directory"
slug: cannot-copy-from-to-a-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:346"
reproduced: false
---

# `%s: cannot copy from/to a directory`

## What it means

A command-line tool was told to copy to or from a path that is a directory, not a file. The copy operation needs a regular file, so a directory path is rejected. The placeholder is the program name.

## When it happens

It occurs in tools such as `pg_combinebackup` or related utilities when a file argument points at a directory.

## How to fix

Point the argument at a regular file, not a directory. Correct the path so the source and destination are files the tool can read and write.

## Example

*Illustrative* — a directory given as a file.

```text
pg_combinebackup: cannot copy from/to a directory
```

## Related

- [cannot create temporary directory](./cannot-create-temporary-directory.md)
- [cannot create temporary subdirectory](./cannot-create-temporary-subdirectory.md)
