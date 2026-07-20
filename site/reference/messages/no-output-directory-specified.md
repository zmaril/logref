---
message: "no output directory specified"
slug: no-output-directory-specified
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:239"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:154"
reproduced: false
---

# `no output directory specified`

## What it means

A tool that writes its results to a directory was run without being told where. The output directory argument is required. The tool cannot proceed with nowhere to write.

## When it happens

It arises from tools such as `pg_basebackup`, `pg_receivewal`, or `pg_dump` directory-format output when the destination directory option (for example `-D`/`--pgdata` or `-D`/`--directory`) is missing.

## How to fix

Provide the output directory option required by the tool, pointing at a writable location. Check the tool's help for the exact flag name, and make sure the path exists (or that the tool is allowed to create it) with adequate permissions.

## Example

*Illustrative* — a base backup with no target directory.

```text
FATAL:  no output directory specified
```

## Related

- [needs a slot to be specified using --slot](./needs-a-slot-to-be-specified-using-slot.md)
- [may only be specified with --create-slot](./may-only-be-specified-with-create-slot.md)
