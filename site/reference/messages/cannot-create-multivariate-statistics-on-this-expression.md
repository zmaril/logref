---
message: "cannot create multivariate statistics on this expression"
slug: cannot-create-multivariate-statistics-on-this-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:394"
reproduced: false
---

# `cannot create multivariate statistics on this expression`

## What it means

A `CREATE STATISTICS` included an expression that is not valid as a statistics target — for example one that is not immutable or references disallowed constructs. Extended statistics can cover expressions, but only ones that meet the requirements for a statistics column.

## When it happens

It occurs when a statistics definition lists an expression the system cannot collect statistics on.

## How to fix

Use expressions that are immutable and reference only the table's columns. Simplify or replace the offending expression so it qualifies as a statistics target.

## Example

*Illustrative* — an invalid statistics expression.

```text
ERROR:  cannot create multivariate statistics on this expression
```

## Related

- [cannot create extended statistics on a single non-virtual column](./cannot-create-extended-statistics-on-a-single-non-virtual-column.md)
- [cannot define statistics for relation](./cannot-define-statistics-for-relation.md)
