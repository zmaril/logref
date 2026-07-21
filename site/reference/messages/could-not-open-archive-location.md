---
message: "could not open archive location \"%s\": %m"
slug: could-not-open-archive-location
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:101"
reproduced: false
---

# `could not open archive location "%s": %m`

## What it means

`pg_archivecleanup` tried to open the archive directory you named and the operating system refused. The `%m` reason gives the cause. It scans this directory to decide which old WAL files can be removed.

## When it happens

It happens when running `pg_archivecleanup` against a path that does not exist, is not a directory, or is not readable by the user running the tool.

## How to fix

Point `pg_archivecleanup` at the correct archive directory and make sure it exists and is readable (and writable, since it removes files) by the invoking user. The `%m` reason names the specific problem.

## Example

*Illustrative* — the archive directory could not be opened.

```text
pg_archivecleanup: fatal: could not open archive location "/var/lib/pg/archive": No such file or directory
```

## Related

- [could not read archive location](./could-not-read-archive-location.md)
- [could not open file restored from archive](./could-not-open-file-restored-from-archive.md)
