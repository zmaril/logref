---
message: "type modifier cannot be specified for shell type \"%s\""
slug: type-modifier-cannot-be-specified-for-shell-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:137"
  - "postgres/src/backend/parser/parse_type.c:352"
reproduced: false
---

# `type modifier cannot be specified for shell type "%s"`

## What it means

A type modifier (like the `(n)` in `varchar(10)`) was applied to a shell type. The placeholder is the type name. A shell type is a placeholder created before a type's full definition exists, and it has no modifier support yet.

## When it happens

It arises during type creation bootstrapping — referencing a not-yet-fully-defined type with a modifier, for example while defining a base type whose input/output functions are not in place.

## How to fix

Do not attach a type modifier to a shell type. Complete the type's definition (its I/O functions and `CREATE TYPE`) first; modifiers can only be used once the type is fully defined and supports them.

## Example

*Illustrative* — a modifier on a shell type.

```text
ERROR:  type modifier cannot be specified for shell type "mytype"
```

## Related

- [type %s does not support subscripted assignment](./type-does-not-support-subscripted-assignment.md)
- [storage "%s" not recognized](./storage-not-recognized.md)
