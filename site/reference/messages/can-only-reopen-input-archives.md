---
message: "can only reopen input archives"
slug: can-only-reopen-input-archives
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:798"
reproduced: false
---

# `can only reopen input archives`

## What it means

`pg_restore` tried to reopen an archive that was opened for output rather than input. Only input archives can be reopened, for example to make a second pass. It is an internal restriction in the archive machinery.

## When it happens

It is an internal guard in `pg_dump`/`pg_restore` archive handling and does not reflect a data problem.

## How to fix

There is no user action for ordinary restores. If it appears, capture the exact `pg_restore` invocation and the archive format, and report it as a possible bug with the tool version.

## Example

*Illustrative* — the reopen guard.

```text
FATAL:  can only reopen input archives
```

## Related

- [calculated crc checksum does not match value stored in file](./calculated-crc-checksum-does-not-match-value-stored-in-file-12a806.md)
- [can only write single tablespace to stdout database has](./can-only-write-single-tablespace-to-stdout-database-has.md)
