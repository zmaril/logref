---
message: "type attribute \"%s\" not recognized"
slug: type-attribute-not-recognized
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:331"
  - "postgres/src/backend/commands/typecmds.c:1506"
  - "postgres/src/backend/commands/typecmds.c:4518"
reproduced: false
---

# `type attribute "%s" not recognized`

## What it means

A base-type definition listed an attribute that is not a valid attribute for a type. `CREATE TYPE` accepts a fixed set of attribute names to describe a type's behavior, and the given name is not one of them.

## When it happens

Running `CREATE TYPE name (...)` with an attribute keyword that is misspelled or not a valid type attribute, sometimes in a dump created by a newer server that used an attribute the current server does not know.

## How to fix

Use a valid type attribute name. Consult the `CREATE TYPE` documentation for the accepted attributes (such as `INPUT`, `OUTPUT`, `INTERNALLENGTH`, `ALIGNMENT`, and others), and correct the spelling. If restoring a dump, confirm the target server version supports the attributes the dump uses.

## Example

*Illustrative* — an unrecognized type attribute.

```sql
CREATE TYPE mytype (INPUT = in_fn, OUTPUT = out_fn, WIDTH = 4);  -- no such attribute
```

## Related

- [alignment is invalid for variable-length type](./alignment-is-invalid-for-variable-length-type.md)
- [invalid value for option](./invalid-value-for-option.md)
