---
message: "argument %d: key must not be null"
slug: argument-key-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonb.c:1156"
reproduced: false
---

# `argument %d: key must not be null`

## What it means

A function that builds a keyed structure (such as a JSON object or a key/value construction) was given a NULL where a key was required, and keys may not be NULL.

## When it happens

It occurs in functions like `json_object`/`jsonb_object` or similar builders when a key position in the argument list is NULL.

## How to fix

Ensure every key argument is non-null. Filter out or replace NULL keys before the call, or use `coalesce` to supply a concrete key. Values may be NULL, but keys must not.

## Example

*Illustrative* — a NULL key in an object constructor.

```sql
SELECT json_object(ARRAY[NULL, 'v']);  -- ERROR:  argument 1: key must not be null
```

## Related

- [argument must not be null](./argument-must-not-be-null.md)
- [array of weight must not contain nulls](./array-of-weight-must-not-contain-nulls.md)
