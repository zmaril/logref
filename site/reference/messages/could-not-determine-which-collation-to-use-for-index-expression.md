---
message: "could not determine which collation to use for index expression"
slug: could-not-determine-which-collation-to-use-for-index-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2117"
reproduced: false
---

# `could not determine which collation to use for index expression`

## What it means

An index on an expression involves a collatable type, but PostgreSQL could not decide which collation to apply. The expression combined collatable inputs with no single collation, leaving the choice ambiguous.

## When it happens

It happens during `CREATE INDEX` on an expression when the indexed expression mixes columns or values of different collations, or uses a value with no determinable collation.

## How to fix

Add an explicit `COLLATE` clause to the indexed expression so the collation is unambiguous, for example `CREATE INDEX ON t ((lower(name) COLLATE "C"))`.

## Example

*Illustrative* — an index expression with an ambiguous collation.

```sql
CREATE INDEX ON t ((a || b));
-- ERROR:  could not determine which collation to use for index expression
```

## Related

- [could not determine which collation to use for partition expression](./could-not-determine-which-collation-to-use-for-partition-expression.md)
- [could not determine which collation to use for view column](./could-not-determine-which-collation-to-use-for-view-column.md)
