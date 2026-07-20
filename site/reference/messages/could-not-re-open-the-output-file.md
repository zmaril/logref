---
message: "could not re-open the output file \"%s\": %m"
slug: could-not-re-open-the-output-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1687"
reproduced: false
---

# `could not re-open the output file "%s": %m`

## What it means

`pg_dumpall` finished writing part of its output and could not reopen the output file to continue. The `%m` reason gives the cause. It reopens the file when switching between sections of the dump.

## When it happens

It happens during `pg_dumpall` when the output file cannot be reopened — usually the file was removed or its directory became unwritable mid-run, or a disk problem on the destination.

## How to fix

Write the dump to a stable, writable location with free space, and avoid moving or deleting the output file while `pg_dumpall` runs. The `%m` reason names the specific problem.

## Example

*Illustrative* — the output file could not be reopened.

```text
pg_dumpall: fatal: could not re-open the output file "all.sql": No such file or directory
```

## Related

- [could not open stdout for appending](./could-not-open-stdout-for-appending.md)
- [could not print result table](./could-not-print-result-table.md)
