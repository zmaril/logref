---
message: "alignment \"%c\" is invalid for variable-length type"
slug: alignment-is-invalid-for-variable-length-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/pg_type.c:307"
  - "postgres/src/backend/catalog/pg_type.c:313"
reproduced: false
---

# `alignment "%c" is invalid for variable-length type`

## What it means

A type definition specified a storage alignment that is not permitted for a variable-length type. Variable-length types must use an alignment compatible with their length header, and the given alignment is too small for that.

## When it happens

Running `CREATE TYPE` for a variable-length type (one with a length header) while setting `ALIGNMENT` to a value such as char alignment that cannot hold the length word, usually when defining a custom base type.

## How to fix

Use an alignment valid for variable-length data — typically `int` or `double` alignment, which accommodate the length header. Consult the `CREATE TYPE` documentation for the alignment requirements of variable-length types, and match the alignment to the type's storage.

## Example

*Illustrative* — a too-small alignment for a varlena type.

```sql
CREATE TYPE t (INTERNALLENGTH = variable, INPUT = i, OUTPUT = o, ALIGNMENT = char);
```

## Related

- [type attribute not recognized](./type-attribute-not-recognized.md)
- [invalid value for option](./invalid-value-for-option.md)
