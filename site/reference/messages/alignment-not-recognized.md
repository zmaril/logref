---
message: "alignment \"%s\" not recognized"
slug: alignment-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:437"
reproduced: false
---

# `alignment "%s" not recognized`

## What it means

A type or catalog definition specified an alignment code the server does not recognize, so it cannot determine the storage alignment for the type.

## When it happens

It occurs in `CREATE TYPE` (or low-level catalog handling) when the `ALIGNMENT` option is given a value other than the supported codes (char, int2, int4, double).

## How to fix

Use one of the recognized alignment specifications for the type — `char`, `int2`, `int4`, or `double` — matching the type's C representation. Fix the `ALIGNMENT` clause in the type definition.

## Example

*Illustrative* — an unknown alignment code.

```text
ERROR:  alignment "quad" not recognized
```

## Related

- [array element type cannot be](./array-element-type-cannot-be.md)
- [affix file contains both old-style and new-style commands](./affix-file-contains-both-old-style-and-new-style-commands.md)
