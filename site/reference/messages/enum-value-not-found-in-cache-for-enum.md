---
message: "enum value %u not found in cache for enum %s"
slug: enum-value-not-found-in-cache-for-enum
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/typcache.c:2745"
  - "postgres/src/backend/utils/cache/typcache.c:2748"
reproduced: false
---

# `enum value %u not found in cache for enum %s`

## What it means

Internal error. The type cache could not find an enum value's sort information for a given OID. The `%u` is the enum value OID and the `%s` is the enum type. It is a cache-consistency guard.

## When it happens

It can arise when an enum value added in an uncommitted or concurrent transaction is used in a context that consults the cached ordering, or under catalog inconsistency. It does not come from ordinary queries.

## How to fix

If it coincides with recently added enum values inside the same transaction, commit before relying on ordering. If it persists, inspect `pg_enum` for the type and report a reproducible case.

## Example

*Illustrative* — an enum value missing from the type cache.

```text
ERROR:  enum value 16500 not found in cache for enum mood
```

## Related

- [enum label already exists](./enum-label-already-exists.md)
- [enum contains no values](./enum-contains-no-values.md)
