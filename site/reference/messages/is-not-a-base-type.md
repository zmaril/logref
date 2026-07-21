---
message: "%s is not a base type"
slug: is-not-a-base-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:4552"
  - "postgres/src/backend/commands/typecmds.c:4561"
reproduced: false
---

# `%s is not a base type`

## What it means

An operation that requires a base (scalar) type was given a type that is not one — for example a composite, domain, enum, or pseudo-type. The placeholder names the type.

## When it happens

It arises when defining or altering type-related objects (such as a type's input/output support, or a use that requires a plain base type) and the named type is of another category.

## How to fix

Supply a base type where one is required. Check the type's category with `\dT name` or by querying `pg_type.typtype`. If you need composite or domain behavior, use the command form intended for that category.

## Example

*Illustrative* — using a composite type where a base type is required.

```text
ERROR:  my_composite is not a base type
```

## Related

- [is not an enum](./is-not-an-enum.md)
- [is not a procedure](./is-not-a-procedure.md)
