---
message: "could not find tuple for attrdef %u"
slug: could-not-find-tuple-for-attrdef
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3223"
  - "postgres/src/backend/catalog/objectaddress.c:5351"
  - "postgres/src/backend/catalog/pg_attrdef.c:234"
reproduced: false
---

# `could not find tuple for attrdef %u`

## What it means

Internal error. Code looked up a column-default entry in `pg_attrdef` by OID and found no row. The placeholder is the attrdef OID. A column default the catalog still references was expected to exist and did not.

## When it happens

A concurrent DDL change that removed the default, or catalog inconsistency in `pg_attrdef`. Not driven by ordinary data.

## How to fix

If it coincides with concurrent `ALTER TABLE ... ALTER COLUMN ... DROP DEFAULT` or similar, retry. If it recurs for one OID, inspect `pg_attrdef`; a dangling reference indicates corruption to investigate. Report reproducible cases.

## Example

*Illustrative* — a column-default row not found.

```text
ERROR:  could not find tuple for attrdef 16730
```

## Related

- [could not find tuple for rule](./could-not-find-tuple-for-rule.md)
- [cache lookup failed for not-null constraint on column of relation](./cache-lookup-failed-for-not-null-constraint-on-column-of-relation-462762.md)
