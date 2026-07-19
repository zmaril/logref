---
message: "Expecting \"tablespace OID/database OID/relation filenode\"."
slug: expecting-tablespace-oid-database-oid-relation-filenode
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1141"
reproduced: false
---

# `Expecting "tablespace OID/database OID/relation filenode".`

## What it means

A `pg_waldump` detail line. It expected a relation-file specifier in the form `tablespace OID/database OID/relation filenode` and the value given did not have that shape.

## When it happens

It accompanies a `pg_waldump` argument error when the `--relation` (or equivalent) filter is not written as three slash-separated numbers identifying the tablespace, database, and relation filenode.

## How to fix

Write the relation filter as `tablespaceOID/databaseOID/relfilenode`, all numeric — for example `1663/16384/24576`. Look up the values in `pg_class.relfilenode`, `pg_database.oid`, and the tablespace OID. Correct the argument and re-run `pg_waldump`.

## Example

*Illustrative* — the accompanying detail line.

```
Expecting "tablespace OID/database OID/relation filenode".
```

## Related

- [Expecting an unsigned integer, "time" or "rand".](./expecting-an-unsigned-integer-time-or-rand.md)
- [Expected a numeric timeline ID.](./expected-a-numeric-timeline-id.md)
