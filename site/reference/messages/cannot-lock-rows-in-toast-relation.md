---
message: "cannot lock rows in TOAST relation \"%s\""
slug: cannot-lock-rows-in-toast-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1245"
reproduced: false
---

# `cannot lock rows in TOAST relation "%s"`

## What it means

A row-locking clause was applied to a query over a TOAST relation. TOAST tables hold out-of-line column data and are managed internally, so their rows cannot be user-locked. The placeholder is the TOAST relation name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads directly from a `pg_toast` relation.

## How to fix

Do not lock or query TOAST tables directly. Work with the owning user table, and let Postgres manage the associated TOAST storage.

## Example

*Illustrative* — FOR UPDATE on a TOAST relation.

```text
ERROR:  cannot lock rows in TOAST relation "pg_toast_16487"
```

## Related

- [cannot lock rows in sequence](./cannot-lock-rows-in-sequence.md)
- [cannot fetch toast data without an active snapshot](./cannot-fetch-toast-data-without-an-active-snapshot.md)
