---
message: "cannot specify statistics kinds when building univariate statistics"
slug: cannot-specify-statistics-kinds-when-building-univariate-statistics
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:421"
reproduced: false
---

# `cannot specify statistics kinds when building univariate statistics`

## What it means

A `CREATE STATISTICS` statement listed statistics kinds while defining statistics on a single expression. Kinds such as `ndistinct` and `dependencies` describe relationships between several columns, so they do not apply to univariate (single-expression) statistics.

## When it happens

It occurs when `CREATE STATISTICS` names one expression and also lists statistics kinds in parentheses.

## How to fix

Drop the kind list to build plain per-expression statistics on the single expression, or list two or more columns if you want multivariate kinds.

## Example

*Illustrative* — kinds requested on one expression.

```sql
CREATE STATISTICS s (ndistinct) ON (a + b) FROM t;
-- ERROR:  cannot specify statistics kinds when building univariate statistics
```

## Related

- [cannot specify both PARSER and COPY options](./cannot-specify-both-parser-and-copy-options.md)
- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
