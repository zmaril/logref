---
message: "could not identify a hash function for type %s"
slug: could-not-identify-a-hash-function-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4199"
  - "postgres/src/backend/utils/adt/multirangetypes.c:2879"
  - "postgres/src/backend/utils/adt/multirangetypes.c:2951"
  - "postgres/src/backend/utils/adt/rangetypes.c:1593"
  - "postgres/src/backend/utils/adt/rangetypes.c:1657"
  - "postgres/src/backend/utils/adt/rowtypes.c:1891"
reproduced: false
---

# `could not identify a hash function for type %s`

## What it means

An operation that needs to hash values could not find a hash function for the type. The placeholder is the type. Hash joins, hash aggregation, hash partitioning, and hash indexes require a hash operator class for the type, and none exists.

## When it happens

Hash-based `GROUP BY`/`DISTINCT`/joins, `PARTITION BY HASH`, or a hash index on a type without a hash operator class — some custom or opaque types, or records/arrays whose element type is not hashable.

## How to fix

Provide a hash operator class for the type (define an equality operator and a hash support function), or avoid hash-based operations on it — an ordering-based plan (`ORDER BY`, merge join) may work if the type is comparable. For hash partitioning, the key type must be hashable; choose a different key or type. For custom types, add the hash opclass.

## Example

*Illustrative* — hash partitioning on a non-hashable type.

```sql
CREATE TABLE t (k uncomparable_type) PARTITION BY HASH (k);
```

Produces:

```text
ERROR:  could not identify a hash function for type uncomparable_type
```

## Related

- [could not identify an equality operator for type %s](./could-not-identify-an-equality-operator-for-type.md)
- [could not identify a comparison function for type %s](./could-not-identify-a-comparison-function-for-type.md)
