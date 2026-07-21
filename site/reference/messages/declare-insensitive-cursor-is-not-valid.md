---
message: "DECLARE INSENSITIVE CURSOR ... %s is not valid"
slug: declare-insensitive-cursor-is-not-valid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_DEFINITION
    code: "42P11"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3432"
reproduced: false
---

# `DECLARE INSENSITIVE CURSOR ... %s is not valid`

## What it means

A `DECLARE ... INSENSITIVE CURSOR` used an option combination the parser does not accept. The placeholder names the offending clause. `INSENSITIVE` promises the cursor will not see later changes, which conflicts with cursor modes that require sensitivity.

## When it happens

It fires while analyzing a `DECLARE` statement when `INSENSITIVE` is combined with a clause that contradicts it, such as `FOR UPDATE`.

## How to fix

Drop the conflicting clause. An `INSENSITIVE` cursor is read-only by definition, so remove `FOR UPDATE`/`FOR SHARE`, or drop `INSENSITIVE` if you need an updatable cursor. PostgreSQL cursors are already effectively insensitive within a transaction, so the keyword is rarely needed.

## Example

*Illustrative* — combining `INSENSITIVE` with row locking.

```sql
DECLARE c INSENSITIVE CURSOR FOR SELECT * FROM orders FOR UPDATE;
```

## Related

- [DECLARE SCROLL CURSOR ... FOR UPDATE/SHARE is not supported](./declare-scroll-cursor-for-update-share-is-not-supported.md)
- [DECLARE SCROLL CURSOR ... is not supported](./declare-scroll-cursor-is-not-supported.md)
