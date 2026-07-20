---
message: "expressions are not supported in included columns"
slug: expressions-are-not-supported-in-included-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2000"
  - "postgres/src/backend/parser/parse_utilcmd.c:1986"
reproduced: false
---

# `expressions are not supported in included columns`

## What it means

An index definition put an expression in the `INCLUDE` list. Included (covering) columns must be plain column references; only the key columns of an index may be expressions.

## When it happens

Writing `CREATE INDEX ... (key) INCLUDE (expr)` where `expr` is an expression rather than a bare column name.

## How to fix

List only plain columns in `INCLUDE`. If you need an expression's value covered, add a generated column for it and include that column, or make it a key column instead.

## Example

*Illustrative* — an expression in INCLUDE.

```text
ERROR:  expressions are not supported in included columns
```

## Related

- [final function with extra arguments must not be declared STRICT](./final-function-with-extra-arguments-must-not-be-declared-strict.md)
- [foreign key constraint cannot be implemented](./foreign-key-constraint-cannot-be-implemented.md)
