---
message: "new bit must be 0 or 1"
slug: new-bit-must-be-0-or-1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/bytea.c:765"
  - "postgres/src/backend/utils/adt/varbit.c:1831"
reproduced: false
---

# `new bit must be 0 or 1`

## What it means

A bit-setting function was given a bit value other than 0 or 1. Individual bits can only be set to those two values. The reference names the offending input indirectly through the message.

## When it happens

It arises from `set_bit(bit, index, newvalue)` or `set_bit(bytea, index, newvalue)` when the `newvalue` argument is not 0 or 1.

## How to fix

Pass 0 or 1 as the new bit value. Check the expression producing it; clamp or validate it to those two values before calling `set_bit`.

## Example

*Illustrative* — a bit value other than 0 or 1.

```sql
SELECT set_bit(B'101', 0, 2);  -- new bit must be 0 or 1
```

## Related

- [invalid length in external bit string](./invalid-length-in-external-bit-string.md)
- [index out of valid range 0](./index-out-of-valid-range-0.md)
