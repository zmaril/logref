---
message: "current database's encoding is not supported with this provider"
slug: current-database-s-encoding-is-not-supported-with-this-provider
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:343"
reproduced: false
---

# `current database's encoding is not supported with this provider`

## What it means

A collation operation asked for a locale provider that cannot work with the current database's encoding. Each collation provider supports a set of encodings, and the database's encoding is not among them for the chosen provider.

## When it happens

It happens when you create or use a collation with a provider — for example the built-in provider or ICU in a specific mode — that does not support the database's server encoding.

## How to fix

Use a provider that supports the database's encoding, or create the database in an encoding the provider supports. The built-in C.UTF-8 locale, for instance, requires a UTF-8 database. Check the provider's encoding requirements against your database encoding before creating the collation.

## Example

*Illustrative* — a provider that does not support the database encoding.

```sql
CREATE COLLATION c (provider = builtin, locale = 'C.UTF-8');
-- ERROR:  current database's encoding is not supported with this provider
```

## Related

- [database locale is incompatible with operating system](./database-locale-is-incompatible-with-operating-system.md)
- [data type is a domain](./data-type-is-a-domain.md)
