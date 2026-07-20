---
message: "lastval is not yet defined in this session"
slug: lastval-is-not-yet-defined-in-this-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/sequence.c:904"
  - "postgres/src/backend/commands/sequence.c:910"
reproduced: false
---

# `lastval is not yet defined in this session`

## What it means

`lastval()` was called before any sequence value was generated in the current session. `lastval()` returns the value most recently produced by `nextval()`, and there is none yet.

## When it happens

It arises when calling `lastval()` in a fresh session (or one that has not yet called `nextval()`), for example right after connecting or after a reset.

## How to fix

Call `nextval('seq')` (directly or via a serial/identity insert) before `lastval()`. If you need the value for a specific sequence regardless of session history, use `currval('seq')` after a `nextval` on that sequence instead.

## Example

*Illustrative* — lastval before any nextval.

```sql
SELECT lastval();  -- nothing generated yet this session
```

## Related

- [no value found for parameter](./no-value-found-for-parameter.md)
- [invalid portal in SPI cursor operation](./invalid-portal-in-spi-cursor-operation.md)
