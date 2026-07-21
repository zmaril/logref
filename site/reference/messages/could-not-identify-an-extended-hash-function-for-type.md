---
message: "could not identify an extended hash function for type %s"
slug: could-not-identify-an-extended-hash-function-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4327"
  - "postgres/src/backend/utils/adt/rowtypes.c:2012"
reproduced: false
---

# `could not identify an extended hash function for type %s`

## What it means

A query needed a 64-bit (extended) hash function for a data type and none is registered. Partitioned-hash and some parallel-hash paths require the extended hash support function, which this type's operator class does not provide.

## When it happens

Hash partitioning on a column of the type, or a hash operation that needs the extended variant, when the type has only the standard 32-bit hash (or no hash) support.

## How to fix

Use a type that has extended hash support for the hashed column, or avoid hash partitioning on this type. For a custom type, add the extended hash support function to its hash operator class.

## Example

*Illustrative* — hash-partitioning on a type without extended hash support.

```text
ERROR:  could not identify an extended hash function for type inet
```

## Related

- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
- [could not implement GROUP BY](./could-not-implement-group-by.md)
