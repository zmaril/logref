---
message: "argument to option \"%s\" must be a list of column names"
slug: argument-to-option-must-be-a-list-of-column-names
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:682"
  - "postgres/src/backend/commands/copy.c:697"
  - "postgres/src/backend/commands/copy.c:712"
  - "postgres/src/backend/commands/copy.c:731"
reproduced: false
---

# `argument to option "%s" must be a list of column names`

## What it means

A command option that expects a list of column names was given something else. The placeholder is the option name. Options like `COPY`'s `FORCE_QUOTE`, `FORCE_NOT_NULL`, or `FORCE_NULL` take a parenthesized list of columns.

## When it happens

Passing a non-list or non-identifier value to a column-list option — for example a bare string, a number, or malformed syntax where `(col1, col2)` is expected.

## How to fix

Write the option's argument as a parenthesized, comma-separated list of column names that exist in the target table — for example `FORCE_QUOTE (a, b)`. Use `*` where the option supports all columns.

## Example

*Illustrative* — a bad FORCE_QUOTE argument.

```sql
COPY t TO STDOUT WITH (FORMAT csv, FORCE_QUOTE 'a');
```

## Related

- [copy requires CSV mode](./copy-requires-csv-mode.md)
- [invalid list syntax in parameter](./invalid-list-syntax-in-parameter.md)
