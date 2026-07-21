---
message: "unrecognized collation provider: %s"
slug: unrecognized-collation-provider
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:228"
  - "postgres/src/bin/pg_dump/pg_dump.c:15091"
  - "postgres/src/bin/pg_dump/pg_dump.c:15159"
reproduced: false
---

# `unrecognized collation provider: %s`

## What it means

A collation provider value was read that is not one of the known providers. Collations come from a fixed set of providers (such as the C library, ICU, or the built-in provider), and the stored or supplied value matched none. It can surface in the server or in pg_dump, at ERROR or FATAL.

## When it happens

A collation catalog entry holds a provider code the running build does not recognize — for example a dump or catalog written by a newer server using a provider the current one lacks — or an internal inconsistency in collation metadata.

## How to fix

Align the software versions. If it appears during restore, use a target server new enough to know the collation provider the dump uses. If it appears in a running server, the collation catalog may be inconsistent or from an incompatible version; capture the collation involved and investigate the version mismatch.

## Example

*Illustrative* — an unknown collation provider.

```text
ERROR:  unrecognized collation provider: x
```

## Related

- [no collation was derived for column with collatable type](./no-collation-was-derived-for-column-with-collatable-type.md)
- [unrecognized collation provider](./unrecognized-collation-provider.md)
