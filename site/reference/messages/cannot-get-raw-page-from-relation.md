---
message: "cannot get raw page from relation \"%s\""
slug: cannot-get-raw-page-from-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pageinspect/rawpage.c:162"
reproduced: true
---

# `cannot get raw page from relation "%s"`

## What it means

The pageinspect extension could not read a raw page from the target because it is not a relation with regular block storage. `get_raw_page()` reads a single physical block, and the object given has none of the expected kind. The placeholder is the relation name.

## When it happens

It occurs when `get_raw_page()` is pointed at an object with no ordinary heap or index storage, such as a view, a foreign table, or a partitioned parent.

## How to fix

Point `get_raw_page()` at a table or index with physical blocks. For partitioned tables, read pages from the individual leaf partitions.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT get_raw_page('repro.child_v', 0);
```

Produces:

```text
ERROR:  cannot get raw page from relation "child_v"
```

## Related

- [cannot get page count of relation](./cannot-get-page-count-of-relation.md)
- [cannot get tuple-level statistics for relation](./cannot-get-tuple-level-statistics-for-relation.md)
