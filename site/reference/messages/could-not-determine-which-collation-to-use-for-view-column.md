---
message: "could not determine which collation to use for view column \"%s\""
slug: could-not-determine-which-collation-to-use-for-view-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/commands/view.c:75"
reproduced: false
---

# `could not determine which collation to use for view column "%s"`

## What it means

A view column's defining expression involves a collatable type, but PostgreSQL could not decide which collation the column should carry. The `%s` names the column. The collation was left ambiguous.

## When it happens

It happens during `CREATE VIEW` (or `CREATE TABLE AS`) when a column's expression mixes inputs of different collations, or uses one with no determinable collation.

## How to fix

Add an explicit `COLLATE` clause to the column's expression in the view definition so its collation is fixed, for example `SELECT (a || b) COLLATE "C" AS c`.

## Example

*Illustrative* — a view column with an ambiguous collation.

```sql
CREATE VIEW v AS SELECT (a COLLATE "C") || (b COLLATE "en_US") AS c FROM t;
-- ERROR:  could not determine which collation to use for view column "c"
```

## Related

- [could not determine which collation to use for index expression](./could-not-determine-which-collation-to-use-for-index-expression.md)
- [could not determine which collation to use for partition expression](./could-not-determine-which-collation-to-use-for-partition-expression.md)
