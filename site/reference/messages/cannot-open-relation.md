---
message: "cannot open relation \"%s\""
slug: cannot-open-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/table/table.c:148"
  - "postgres/src/backend/optimizer/util/plancat.c:147"
reproduced: false
---

# `cannot open relation "%s"`

## What it means

Code tried to open a relation whose kind does not support being opened in the requested way. The placeholder is the relation name. For example, opening a partitioned table or a view as if it had physical storage to scan is rejected.

## When it happens

An operation that assumes storage-backed access reached a relation without storage — a partitioned parent, a view, or a foreign table — through a path that expected an ordinary heap.

## How to fix

Direct the operation at a relation kind it supports: the leaf partitions rather than the partitioned parent, the base tables rather than the view. If this surfaced from application code, check that the target relation is the concrete table you intended.

## Example

*Illustrative* — opening a partitioned parent for storage access.

```text
ERROR:  cannot open relation "parted"
```

## Related

- [cannot extend file beyond blocks](./cannot-extend-file-beyond-blocks.md)
- [cannot query non-catalog table during logical decoding](./cannot-query-non-catalog-table-during-logical-decoding.md)
