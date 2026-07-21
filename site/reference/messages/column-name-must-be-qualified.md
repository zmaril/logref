---
message: "column name must be qualified"
slug: column-name-must-be-qualified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1613"
  - "postgres/src/backend/catalog/objectaddress.c:1666"
reproduced: false
---

# `column name must be qualified`

## What it means

An object-address or column reference needed a schema/table qualification but was given a bare column name. Postgres could not resolve which table's column is meant without qualification in this context.

## When it happens

Referring to a column by name alone in a context — such as certain `COMMENT`, `SECURITY LABEL`, or object-address operations — where the table must be named explicitly.

## How to fix

Qualify the column with its table (and schema if needed), for example `schema.table.column`. Supply the full path the command expects so the column reference is unambiguous.

## Example

*Illustrative* — an unqualified column in a context needing qualification.

```text
ERROR:  column name must be qualified
```

## Related

- [column is not in index](./column-is-not-in-index.md)
- [cannot use type in RETURNING clause of](./cannot-use-type-in-returning-clause-of.md)
