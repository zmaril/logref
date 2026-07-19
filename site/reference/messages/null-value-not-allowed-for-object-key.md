---
message: "null value not allowed for object key"
slug: null-value-not-allowed-for-object-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:1044"
  - "postgres/src/backend/utils/adt/json.c:1243"
  - "postgres/src/backend/utils/adt/json.c:1425"
  - "postgres/src/backend/utils/adt/json.c:1499"
  - "postgres/src/backend/utils/adt/jsonb.c:1336"
  - "postgres/src/backend/utils/adt/jsonb.c:1426"
reproduced: false
---

# `null value not allowed for object key`

## What it means

A JSON object was being built and one of the supplied keys was SQL `NULL`. JSON object keys must be strings and can never be null, so the construction is rejected. Values may be null; keys may not.

## When it happens

Calling `json_object`/`jsonb_object`, `json_build_object`/`jsonb_build_object`, or `json_object_agg` where the key argument evaluates to `NULL` — often because a column used as the key contains nulls.

## How to fix

Ensure the key expression is never null: filter out rows with a null key, or coalesce it to a sentinel string with `COALESCE(key, '...')`. If nulls are meaningful, decide how they should be represented as a string before building the object.

## Example

*Illustrative* — a null key passed to json_build_object.

```sql
SELECT json_build_object(NULL, 1);
```

## Related

- [array must have even number of elements](./array-must-have-even-number-of-elements.md)
- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
