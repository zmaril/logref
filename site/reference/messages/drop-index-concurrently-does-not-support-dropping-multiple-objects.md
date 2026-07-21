---
message: "DROP INDEX CONCURRENTLY does not support dropping multiple objects"
slug: drop-index-concurrently-does-not-support-dropping-multiple-objects
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1616"
reproduced: true
---

# `DROP INDEX CONCURRENTLY does not support dropping multiple objects`

## What it means

`DROP INDEX CONCURRENTLY` listed more than one index. The concurrent form can drop only a single index per command.

## When it happens

It fires from `DROP INDEX CONCURRENTLY a, b` or a similar multi-index list.

## How to fix

Issue one `DROP INDEX CONCURRENTLY` per index, in separate commands. If you can accept a brief exclusive lock, a plain `DROP INDEX a, b` can drop several at once.

## Example

*Reproduced* — captured from `reproducers/scenarios/35_ddl_object_lifecycle.sql`.

```sql
DROP INDEX CONCURRENTLY s35.pidx_idx, s35.pidx1_a_idx;
```

Produces:

```text
ERROR:  DROP INDEX CONCURRENTLY does not support dropping multiple objects
```

## Related

- [DROP INDEX CONCURRENTLY does not support CASCADE](./drop-index-concurrently-does-not-support-cascade.md)
- [DROP INDEX CONCURRENTLY must be first action in transaction](./drop-index-concurrently-must-be-first-action-in-transaction.md)
