---
message: "cannot get tuple-level statistics for relation \"%s\""
slug: cannot-get-tuple-level-statistics-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/pgstattuple/pgstattuple.c:302"
reproduced: false
---

# `cannot get tuple-level statistics for relation "%s"`

## What it means

A pgstattuple function was asked for tuple-level statistics on a relation whose access method does not support them. The function scans tuples directly, and the target's storage type does not expose that. The placeholder is the relation name.

## When it happens

It occurs when `pgstattuple()` is pointed at a relation using an access method or object kind it does not handle, such as certain index types or a non-heap storage engine.

## How to fix

Run the function against a supported table or index type. Consult the pgstattuple documentation for the access methods it supports, and choose an object of a supported kind.

## Example

*Illustrative* — tuple statistics on an unsupported access method.

```text
ERROR:  cannot get tuple-level statistics for relation "my_brin_idx"
```

## Related

- [cannot get page count of relation](./cannot-get-page-count-of-relation.md)
- [cannot get raw page from relation](./cannot-get-raw-page-from-relation.md)
