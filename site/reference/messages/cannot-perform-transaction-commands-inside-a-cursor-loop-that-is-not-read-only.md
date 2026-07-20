---
message: "cannot perform transaction commands inside a cursor loop that is not read-only"
slug: cannot-perform-transaction-commands-inside-a-cursor-loop-that-is-not-read-only
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:1232"
reproduced: false
---

# `cannot perform transaction commands inside a cursor loop that is not read-only`

## What it means

A transaction control command (such as `COMMIT` or `ROLLBACK` in a procedure) was issued inside a `FOR` loop over a cursor that is not read-only. Committing mid-loop would invalidate the open writable cursor, so it is rejected.

## When it happens

It occurs in a PL/pgSQL procedure that runs a `FOR` loop over a query and calls `COMMIT`/`ROLLBACK` inside the loop while the cursor may modify data.

## How to fix

Make the loop read-only so transaction control is allowed, or restructure so commits happen outside the cursor loop — collect the keys first, then process and commit them in a separate loop.

## Example

*Illustrative* — COMMIT inside a writable cursor loop.

```text
ERROR:  cannot perform transaction commands inside a cursor loop that is not read-only
```

## Related

- [cannot open query as cursor](./cannot-open-query-as-cursor.md)
- [cannot roll back while a subtransaction is active](./cannot-roll-back-while-a-subtransaction-is-active.md)
