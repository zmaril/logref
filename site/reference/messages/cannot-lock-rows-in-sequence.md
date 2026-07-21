---
message: "cannot lock rows in sequence \"%s\""
slug: cannot-lock-rows-in-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1238"
reproduced: true
---

# `cannot lock rows in sequence "%s"`

## What it means

A row-locking clause was applied to a query that reads a sequence. A sequence is not a table of user rows, so `FOR UPDATE`/`FOR SHARE` locking does not apply. The placeholder is the sequence name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from a sequence object.

## How to fix

Remove the row-locking clause when reading a sequence. Use `nextval()` and `setval()` to manipulate a sequence, which handle concurrency on their own.

## Example

*Reproduced* — captured from `reproducers/scenarios/52_locks_rowmarks_advisory.sql`.

```sql
SELECT * FROM repro.churn_id_seq FOR UPDATE;
```

Produces:

```text
ERROR:  cannot lock rows in sequence "churn_id_seq"
```

## Related

- [cannot lock rows in view](./cannot-lock-rows-in-view.md)
- [cannot lock rows in TOAST relation](./cannot-lock-rows-in-toast-relation.md)
