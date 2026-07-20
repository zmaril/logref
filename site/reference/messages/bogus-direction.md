---
message: "bogus direction"
slug: bogus-direction
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/tcop/pquery.c:1602"
reproduced: false
---

# `bogus direction`

## What it means

A cursor or scan operation was handed a fetch direction value that is neither forward nor backward. Scan directions come from a small fixed set, and an out-of-set value is invalid. It is an internal guard.

## When it happens

It is a can't-happen check in the executor. It would only appear from a bug in cursor or scan handling, not from a `FETCH` written in SQL.

## How to fix

There is no user action for ordinary SQL. If it appears, capture the cursor operations and any extensions that drive scans, and report it as a possible bug.

## Example

*Illustrative* — an invalid scan direction.

```text
ERROR:  bogus direction
```

## Related

- [bogus resno in targetlist](./bogus-resno-in-targetlist.md)
- [before_stmt_triggers_fired called outside of query](./before-stmt-triggers-fired-called-outside-of-query.md)
