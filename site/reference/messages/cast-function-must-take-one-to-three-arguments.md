---
message: "cast function must take one to three arguments"
slug: cast-function-must-take-one-to-three-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1625"
reproduced: true
---

# `cast function must take one to three arguments`

## What it means

A `CREATE CAST ... WITH FUNCTION` named a function with the wrong number of parameters. A cast function takes the source value, and optionally a type modifier and an explicit-cast flag, so it must have one, two, or three parameters.

## When it happens

It occurs on `CREATE CAST` when the referenced function has zero parameters or more than three.

## How to fix

Define the cast function with the source type as its first parameter, and add the optional `integer` type-modifier and `boolean` explicit-flag parameters only if you need them. Match the signature the documentation describes.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE CAST (int AS text) WITH FUNCTION now();
```

Produces:

```text
ERROR:  cast function must take one to three arguments
```

## Related

- [cast function must not return a set](./cast-function-must-not-return-a-set.md)
- [cast function must not be volatile](./cast-function-must-not-be-volatile.md)
