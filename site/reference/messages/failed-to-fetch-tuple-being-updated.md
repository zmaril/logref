---
message: "failed to fetch tuple being updated"
slug: failed-to-fetch-tuple-being-updated
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:2327"
  - "postgres/src/backend/executor/nodeModifyTable.c:2940"
  - "postgres/src/backend/executor/nodeModifyTable.c:5005"
reproduced: false
---

# `failed to fetch tuple being updated`

## What it means

Internal error. During an `UPDATE`/`DELETE`, the executor tried to re-fetch the specific tuple version it was about to modify and could not. The placeholder-free message is a consistency check in the update path: the row it located should still be fetchable.

## When it happens

It does not arise from ordinary DML in the usual case. It can point to an internal inconsistency in concurrent update handling, a table access method or FDW bug, or heap corruption, rather than to the SQL itself.

## How to fix

If it is transient under heavy concurrent updates, a retry may succeed. If it recurs on a specific table, check that table for corruption with `amcheck`/`pg_amcheck`, and suspect any custom table access method or FDW involved. Capture the statement and report reproducible cases.

## Example

*Illustrative* — a tuple that could not be re-fetched for update.

```text
ERROR:  failed to fetch tuple being updated
```

## Related

- [tuple to be updated was already modified by an operation triggered by the current command](./tuple-to-be-updated-was-already-modified-by-an-operation-triggered-by-the.md)
- [could not find junk column](./could-not-find-junk-column.md)
