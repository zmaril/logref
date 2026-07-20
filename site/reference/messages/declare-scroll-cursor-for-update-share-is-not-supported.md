---
message: "DECLARE SCROLL CURSOR ... FOR UPDATE/SHARE is not supported"
slug: declare-scroll-cursor-for-update-share-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/spi.c:1717"
reproduced: false
---

# `DECLARE SCROLL CURSOR ... FOR UPDATE/SHARE is not supported`

## What it means

A cursor was declared `SCROLL` together with `FOR UPDATE` or `FOR SHARE`. PostgreSQL cannot provide scrollable (backward-fetchable) access for a row-locking cursor, so the combination is rejected.

## When it happens

It fires when opening a cursor through SPI or SQL whose declaration asks for both scrollability and row-level locking.

## How to fix

Choose one. Drop `SCROLL` if you need `FOR UPDATE`/`FOR SHARE` locking, or drop the locking clause if you need to fetch backward. If you need both behaviours, fetch the rows without locking and lock the target rows explicitly with a separate `SELECT ... FOR UPDATE`.

## Example

*Illustrative* — asking for a scrollable locking cursor.

```sql
DECLARE c SCROLL CURSOR FOR SELECT * FROM orders FOR UPDATE;
```

## Related

- [DECLARE SCROLL CURSOR ... is not supported](./declare-scroll-cursor-is-not-supported.md)
- [DECLARE INSENSITIVE CURSOR ... is not valid](./declare-insensitive-cursor-is-not-valid.md)
