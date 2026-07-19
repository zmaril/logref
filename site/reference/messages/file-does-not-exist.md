---
message: "file \"%s\" does not exist"
slug: file-does-not-exist
passthrough: false
api: [pg_log_error, pg_log_warning]
level: [ERROR, WARNING]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:1017"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:125"
reproduced: false
---

# `file "%s" does not exist`

## What it means

A file expected by a tool was not found. The `%s` is the path. It fires in `initdb` or `pg_combinebackup` when a required input file is absent. Severity is ERROR or WARNING by site.

## When it happens

An input file (an `initdb` template, or a backup file listed in a manifest) was missing when the tool went to read it.

## How to fix

Confirm the file exists at the expected path and that the installation or backup is complete. Restore the missing file or fix the path, then rerun.

## Example

*Illustrative* — a required input file is missing.

```text
pg_combinebackup: error: file "base/1/1259" does not exist
```

## Related

- [could not open input file](./could-not-open-input-file-d824fe.md)
- [duplicate source file](./duplicate-source-file.md)
