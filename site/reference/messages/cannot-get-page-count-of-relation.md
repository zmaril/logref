---
message: "cannot get page count of relation \"%s\""
slug: cannot-get-page-count-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pgstattuple/pgstatindex.c:479"
reproduced: false
---

# `cannot get page count of relation "%s"`

## What it means

The pgstattuple/pgstatindex extension could not count the pages of the target because it is not a relation with countable storage. The function expects an index or table with a physical file, and the object given does not qualify. The placeholder is the relation name.

## When it happens

It occurs when a pgstatindex function is pointed at an object that has no on-disk pages of the expected kind, such as a view, a partitioned (parent) index, or an unsupported access method.

## How to fix

Point the function at a concrete index or table with physical storage. For partitioned objects, inspect individual leaf partitions rather than the parent.

## Example

*Illustrative* — page count requested for an unsupported object.

```text
ERROR:  cannot get page count of relation "my_view"
```

## Related

- [cannot get raw page from relation](./cannot-get-raw-page-from-relation.md)
- [cannot get tuple-level statistics for relation](./cannot-get-tuple-level-statistics-for-relation.md)
