---
message: "wrong number of index expressions"
slug: wrong-number-of-index-expressions
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgutils.c:155"
  - "postgres/src/backend/access/spgist/spgutils.c:161"
  - "postgres/src/backend/catalog/index.c:2790"
  - "postgres/src/backend/catalog/index.c:2801"
  - "postgres/src/backend/optimizer/path/indxpath.c:4411"
  - "postgres/src/backend/optimizer/path/indxpath.c:4416"
  - "postgres/src/backend/optimizer/util/plancat.c:2198"
  - "postgres/src/backend/optimizer/util/plancat.c:2210"
reproduced: false
---

# `wrong number of index expressions`

## What it means

Internal error. The number of index key expressions did not match the number the index catalog says it has — the `pg_index` `indexprs` list is inconsistent with the index's column count. It signals a corrupted or mismatched index definition.

## When it happens

Catalog inconsistency in an index's expression list, a bug in index-definition handling, or an extension that manipulates index metadata. Ordinary index use does not trigger it.

## How to fix

Suspect the index definition. `REINDEX` the affected index, or drop and recreate it from a correct definition. If the catalog is genuinely inconsistent, treat it as corruption and investigate (restore from backup if needed). Report reproducible cases.

## Example

*Illustrative* — an index with inconsistent expression metadata.

```text
ERROR:  wrong number of index expressions
```

## Related

- [too few entries in indexprs list](./too-few-entries-in-indexprs-list.md)
- [cache lookup failed for index](./cache-lookup-failed-for-index.md)
