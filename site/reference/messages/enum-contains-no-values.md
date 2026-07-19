---
message: "enum %s contains no values"
slug: enum-contains-no-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/adt/enum.c:457"
  - "postgres/src/backend/utils/adt/enum.c:486"
reproduced: false
---

# `enum %s contains no values`

## What it means

An operation needed a value from an enum type that has no labels. The `%s` is the type name. An empty enum offers nothing to return or compare.

## When it happens

Using functions such as `enum_first`/`enum_last` on an enum whose labels were all removed, or otherwise relying on an enum that currently defines no values.

## How to fix

Add labels to the enum with `ALTER TYPE ... ADD VALUE`, or avoid operations that require a value from an empty enum. An enum should normally define at least one label.

## Example

*Illustrative* — enum_first on an empty enum.

```text
ERROR:  enum mood contains no values
```

## Related

- [enum label already exists](./enum-label-already-exists.md)
- [enum value not found in cache for enum](./enum-value-not-found-in-cache-for-enum.md)
