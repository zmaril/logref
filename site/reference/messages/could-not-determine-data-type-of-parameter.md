---
message: "could not determine data type of parameter $%d"
slug: could-not-determine-data-type-of-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_PARAMETER
    code: "42P08"
  - symbol: ERRCODE_INDETERMINATE_DATATYPE
    code: "42P18"
call_sites:
  - "postgres/src/backend/parser/parse_param.c:308"
  - "postgres/src/backend/tcop/postgres.c:750"
reproduced: false
---

# `could not determine data type of parameter $%d`

## What it means

A prepared statement used a parameter placeholder whose type Postgres could not infer from context. The placeholder is the parameter number. Without an explicit type or a usage that pins one, the parameter's type is ambiguous.

## When it happens

Preparing a statement where `$n` appears only in positions that do not determine its type — for example on both sides of a construct that gives no type hint, or passed to a polymorphic function without other typed arguments.

## How to fix

Cast the parameter explicitly where it appears (`$1::int`), or declare its type when preparing (`PREPARE s (int) AS ...`). Give the parameter a context or annotation that fixes its type.

## Example

*Illustrative* — an unresolvable parameter type.

```sql
PREPARE s AS SELECT $1;
-- ERROR:  could not determine data type of parameter $1
```

## Related

- [could not determine data type of input](./could-not-determine-data-type-of-input.md)
- [could not determine interpretation of row comparison operator](./could-not-determine-interpretation-of-row-comparison-operator.md)
