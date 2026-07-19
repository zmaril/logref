---
message: "cache lookup failed for ordering operator for type %u"
slug: cache-lookup-failed-for-ordering-operator-for-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/dependencies.c:265"
  - "postgres/src/backend/statistics/mcv.c:361"
  - "postgres/src/backend/statistics/mvdistinct.c:467"
reproduced: false
---

# `cache lookup failed for ordering operator for type %u`

## What it means

Internal error. Code (here extended-statistics dependency analysis) could not find the default ordering operator (the btree `<` operator) for a type by OID. The placeholder is the type OID. It expected the type to have a default btree ordering operator and did not find one in the catalog.

## When it happens

A concurrent drop of the operator or its operator class, catalog inconsistency, or a type whose default btree opclass is missing when code assumed it had one. Not driven by ordinary data.

## How to fix

If concurrent DDL removed the operator/opclass, retry. If a custom type is involved, ensure it has a complete default btree operator class. Persistent cases on core types indicate corruption worth investigating and reporting.

## Example

*Illustrative* — a missing ordering operator for a type.

```text
ERROR:  cache lookup failed for ordering operator for type 16450
```

## Related

- [cache lookup failed for opfamily](./cache-lookup-failed-for-opfamily.md)
- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
