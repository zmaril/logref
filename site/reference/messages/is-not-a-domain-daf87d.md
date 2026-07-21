---
message: "%s is not a domain"
slug: is-not-a-domain-daf87d
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3532"
  - "postgres/src/backend/commands/typecmds.c:3810"
  - "postgres/src/backend/commands/typecmds.c:3895"
  - "postgres/src/backend/commands/typecmds.c:4111"
reproduced: true
---

# `%s is not a domain`

## What it means

A command that operates on a domain was given a type that is not a domain. The placeholder is the type name. Domains are user-defined types built on a base type with constraints; domain-only operations reject ordinary base or composite types.

## When it happens

Running `ALTER DOMAIN`, adding/dropping a domain constraint, or another domain-specific command against a type that is not a domain (a base type, composite, or enum).

## How to fix

Verify the type is actually a domain (`\dD` in psql, or `SELECT typname FROM pg_type WHERE typtype = 'd'`). Use the command appropriate to the type you have (for example `ALTER TYPE` for a composite/enum), or name a real domain.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER DOMAIN s37.mood SET NOT NULL;
```

Produces:

```text
ERROR:  s37.mood is not a domain
```

## Related

- [is not an index](./is-not-an-index.md)
- [relation does not have a composite type](./relation-does-not-have-a-composite-type.md)
