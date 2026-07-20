---
message: "cannot look at latest visible tid for relation \"%s.%s\""
slug: cannot-look-at-latest-visible-tid-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/tid.c:343"
reproduced: false
---

# `cannot look at latest visible tid for relation "%s.%s"`

## What it means

A function that inspects the latest visible tuple id was applied to a relation whose access method does not support the operation. The feature needs a storage engine that can report the newest visible row version, and this relation's does not. The placeholders are the schema and relation names.

## When it happens

It occurs when a `tid`-related function or feature runs against a table using an access method that cannot answer the latest-visible-tid request.

## How to fix

Use the operation on a heap table that supports it, or avoid the tid-based feature on relations backed by access methods that do not implement it. Consult the access method's capabilities.

## Example

*Illustrative* — latest-visible-tid on an unsupported access method.

```text
ERROR:  cannot look at latest visible tid for relation "public.my_tbl"
```

## Related

- [cannot freeze committed xmax](./cannot-freeze-committed-xmax.md)
- [cannot get tuple-level statistics for relation](./cannot-get-tuple-level-statistics-for-relation.md)
