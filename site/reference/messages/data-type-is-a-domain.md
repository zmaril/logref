---
message: "data type %s is a domain"
slug: data-type-is-a-domain
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1869"
reproduced: false
---

# `data type %s is a domain`

## What it means

A command that requires a base type was given a domain. The placeholder is the type. Certain definitions — for example some function or aggregate roles — do not accept a domain in that position. The server reports it as the wrong kind of object.

## When it happens

It happens when you use a domain where a plain base type is required, such as in a context that must operate on the underlying type rather than a constrained domain over it.

## How to fix

Use the domain's underlying base type in that position instead of the domain. If you need the domain's constraints, apply them separately; the specific definition here works on base types, not domains.

## Example

*Illustrative* — a domain where a base type is required.

```sql
CREATE DOMAIN posint AS int CHECK (VALUE > 0);
CREATE FUNCTION f() RETURNS SETOF posint AS '...' LANGUAGE c;
-- ERROR:  data type posint is a domain
```

## Related

- [data type is a pseudo-type](./data-type-is-a-pseudo-type.md)
- [data type is not an array type](./data-type-is-not-an-array-type.md)
