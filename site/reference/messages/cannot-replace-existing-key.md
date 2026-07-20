---
message: "cannot replace existing key"
slug: cannot-replace-existing-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5205"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5236"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5306"
reproduced: false
---

# `cannot replace existing key`

## What it means

A `jsonb` insert operation that is only allowed to add a new key found the key already present. The path-based insert functions can be told to insert without overwriting; when the target key exists and overwrite was not requested, the operation refuses rather than replacing the value.

## When it happens

Using `jsonb_insert` (which inserts, not upserts) at a path whose key already exists, without the argument that permits replacing an existing value.

## How to fix

If you intend to overwrite, use `jsonb_set` (or `jsonb_insert` with its `insert_after`/replace semantics as appropriate). If you intend strictly to add, check for the key first or target a path that does not already exist. Choose the function that matches insert-only versus replace intent.

## Example

*Illustrative* — inserting over an existing key.

```sql
SELECT jsonb_insert('{"a":1}', '{a}', '2');  -- cannot replace existing key
```

## Related

- [cannot delete from scalar](./cannot-delete-from-scalar.md)
- [cannot call on an array](./cannot-call-on-an-array.md)
