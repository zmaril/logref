---
message: "could not open file \"%s\""
slug: could-not-open-file-c6e6a4
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:143"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1299"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1329"
reproduced: false
---

# `could not open file "%s"`

## What it means

A tool (here `pg_waldump`'s archive path) could not open a file it needs. The placeholder is the file name. Unlike the more detailed open errors, this bare form reports that the named file could not be opened for reading, without a specific OS reason attached at this site.

## When it happens

The file does not exist at the expected location, the path or name is wrong, or the process lacks permission to read it — for example a WAL segment not present in the archive directory being scanned.

## How to fix

Confirm the file exists at the path the tool expects and that the invoking user can read it. Check the directory and file-name arguments, and for WAL tooling ensure the segment is present in the archive/`pg_wal` location being read. Correct the path or restore the missing file.

## Example

*Illustrative* — a missing file for pg_waldump.

```text
pg_waldump: error: could not open file "000000010000000000000009"
```

## Related

- [could not find WAL file](./could-not-find-wal-file.md)
- [could not open output file](./could-not-open-output-file-202c64.md)
