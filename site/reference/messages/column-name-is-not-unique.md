---
message: "column name \"%s\" is not unique"
slug: column-name-is-not-unique
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:825"
reproduced: false
---

# `column name "%s" is not unique`

## What it means

A column reference or definition used a name that matches more than one column in scope, and Postgres could not tell which one was meant. The name is ambiguous.

## When it happens

It happens in contexts such as a record- or row-returning function's column definition list, or a construct that expects unique output names, when two candidate columns share the name.

## How to fix

Qualify or rename the columns so each name is unique. Use table aliases, or give the columns distinct names in the definition list, then rerun.

## Example

*Illustrative* — an ambiguous column name.

```text
ERROR:  column name "id" is not unique
```

## Related

- [column name specified more than once](./column-name-specified-more-than-once.md)
- [column of relation appears more than once](./column-of-relation-appears-more-than-once.md)
