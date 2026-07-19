---
message: "null value not allowed for hstore key"
slug: null-value-not-allowed-for-hstore-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:534"
  - "postgres/contrib/hstore/hstore_io.c:682"
  - "postgres/contrib/hstore/hstore_io.c:776"
reproduced: false
---

# `null value not allowed for hstore key`

## What it means

An hstore value was constructed with a null key. hstore maps text keys to text-or-null values, and while values may be null, keys may not.

## When it happens

Building an hstore from arrays or rows where a key element is `NULL` — for example `hstore(keys_array, values_array)` with a null in the keys array, or a per-row conversion where a key column is null.

## How to fix

Ensure every key is non-null before constructing the hstore. Filter out or replace null keys in the source, and check the query that produces the key array or key column so no null reaches the constructor.

## Example

*Illustrative* — a null key in an hstore constructor.

```sql
SELECT hstore(ARRAY['a', NULL], ARRAY['1','2']);  -- null key not allowed
```

## Related

- [null value not allowed for object key](./null-value-not-allowed-for-object-key.md)
- [array subscript in assignment must not be null](./array-subscript-in-assignment-must-not-be-null.md)
