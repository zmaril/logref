---
message: "skipping reindex of invalid index \"%s.%s\""
slug: skipping-reindex-of-invalid-index
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3833"
  - "postgres/src/backend/commands/indexcmds.c:3886"
reproduced: false
---

# `skipping reindex of invalid index "%s.%s"`

## What it means

A database-wide or schema-wide reindex left an index alone because it is marked invalid — usually the residue of a failed concurrent index build — since reindexing it as-is would not make it usable.

## When it happens

It is emitted at WARNING by `REINDEX DATABASE`/`REINDEX SCHEMA` when it encounters an index whose `pg_index.indisvalid` is false.

## Is this a problem?

Invalid indexes are not automatically repaired by a bulk reindex. Drop the invalid index and rebuild it (ideally with `CREATE INDEX CONCURRENTLY`), or run `REINDEX INDEX` naming it explicitly if you want to attempt an in-place rebuild. Find them by querying `pg_index` for `indisvalid = false`.

## Example

*Illustrative* — a bulk reindex skipping an invalid index.

```text
WARNING:  skipping reindex of invalid index "public.orders_pkey_ccnew"
```

## Related

- [table was reindexed](./table-was-reindexed.md)
- [skipping special file](./skipping-special-file.md)
