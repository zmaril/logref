---
message: "could not read archive location \"%s\": %m"
slug: could-not-read-archive-location
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:170"
reproduced: false
---

# `could not read archive location "%s": %m`

## What it means

`pg_archivecleanup` opened the archive directory but could not read its entries. The `%m` reason gives the cause. It lists the directory to decide which old WAL files are safe to remove.

## When it happens

It happens when running `pg_archivecleanup` against a directory it can open but not read through — usually a permissions problem partway through, or an I/O error on the archive storage.

## How to fix

Make sure the archive directory is fully readable by the user running the tool and that its storage is healthy, then rerun. The `%m` reason names the specific problem.

## Example

*Illustrative* — the archive directory could not be read.

```text
pg_archivecleanup: fatal: could not read archive location "/var/lib/pg/archive": Input/output error
```

## Related

- [could not open archive location](./could-not-open-archive-location.md)
- [could not open file restored from archive](./could-not-open-file-restored-from-archive.md)
