---
message: "data type %s is a pseudo-type"
slug: data-type-is-a-pseudo-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1863"
reproduced: false
---

# `data type %s is a pseudo-type`

## What it means

A command that requires a real, concrete type was given a pseudo-type. The placeholder is the type. Pseudo-types like `anyelement`, `record`, or `trigger` stand in for classes of types and cannot be used where a concrete type is required. The server reports it as the wrong kind of object.

## When it happens

It happens when a pseudo-type appears in a position that needs an actual storable type — for example defining something over `record` or `any` where a concrete type is expected.

## How to fix

Use a concrete data type in that position. Pseudo-types are only valid in the specific contexts that support them (such as polymorphic function arguments); replace it with the real type you intend.

## Example

*Illustrative* — a pseudo-type where a concrete type is required.

```sql
CREATE FUNCTION f() RETURNS SETOF record AS '...' LANGUAGE c;
-- ERROR:  data type record is a pseudo-type
```

## Related

- [data type is a domain](./data-type-is-a-domain.md)
- [data type is not an array type](./data-type-is-not-an-array-type.md)
