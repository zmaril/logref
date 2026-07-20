---
message: "no collation was derived for column \"%s\" with collatable type %s"
slug: no-collation-was-derived-for-column-with-collatable-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/heap.c:705"
  - "postgres/src/backend/commands/createas.c:198"
  - "postgres/src/backend/commands/createas.c:510"
reproduced: false
---

# `no collation was derived for column "%s" with collatable type %s`

## What it means

A column of a collatable type (such as `text`) was defined in a context where its collation could not be determined. Collatable columns need a collation, and none could be inferred from the inputs or the surrounding definition.

## When it happens

Creating a table from a query (`CREATE TABLE ... AS`, `SELECT INTO`, or a materialized view) whose expression mixes collations that cannot be resolved to one, or where an expression yields a collatable type with no derivable collation.

## How to fix

Give the column an explicit collation with a `COLLATE` clause on the source expression, for example `expr COLLATE "C"` or a named collation. Resolving the collation conflict in the underlying query, so all collatable inputs agree, also fixes it.

## Example

*Illustrative* — an unresolved collation in a created column.

```sql
CREATE TABLE t AS SELECT a || b AS c FROM src;  -- add COLLATE if a and b conflict
```

## Related

- [could not determine which collation to use for string comparison](./could-not-determine-which-collation-to-use-for-string-comparison.md)
- [collation mismatch between explicit collations and](./collation-mismatch-between-explicit-collations-and.md)
