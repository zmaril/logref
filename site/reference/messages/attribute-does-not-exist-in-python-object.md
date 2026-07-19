---
message: "attribute \"%s\" does not exist in Python object"
slug: attribute-does-not-exist-in-python-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/pl/plpython/plpy_typeio.c:1539"
reproduced: false
---

# `attribute "%s" does not exist in Python object`

## What it means

A PL/Python function returning a composite type produced a Python object that has no attribute for one of the result columns. The placeholder is the missing attribute name.

## When it happens

It occurs when a `plpython` function is declared to return a row or `SETOF` a composite type, and the returned mapping, sequence, or object omits a field that the declared type requires.

## How to fix

Make the returned object expose every column of the declared composite type. Return a dictionary keyed by the exact column names, a sequence in column order, or an object with matching attributes, and confirm the field name matches the type's column name including case.

## Example

*Illustrative* — a returned object missing a declared column.

```text
ERROR:  attribute "amount" does not exist in Python object
```

## Related

- [attribute does not exist](./attribute-does-not-exist.md)
- [attribute of type has wrong type](./attribute-of-type-has-wrong-type.md)
