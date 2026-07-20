---
message: "could not find parent extension for %s %s"
slug: could-not-find-parent-extension-for
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:6019"
reproduced: false
---

# `could not find parent extension for %s %s`

## What it means

`pg_dump` could not determine the extension that owns an object it is dumping. The `%s` values describe the object. Extension-owned objects must map back to a parent extension, and this one did not.

## When it happens

It happens during a dump when an object is marked as part of an extension but the extension itself cannot be found, usually from a catalog inconsistency or concurrent DDL during the dump.

## How to fix

Dump against a quiet database so extension membership does not change mid-dump. If the catalogs are stable and it still appears, check `pg_depend` for the object's extension link and report a reproducible case.

## Example

*Illustrative* — an extension-owned object with no parent.

```text
pg_dump: fatal: could not find parent extension for function my_func(integer)
```

## Related

- [could not find a legal dump ordering for memberships in role](./could-not-find-a-legal-dump-ordering-for-memberships-in-role.md)
- [could not find index attname](./could-not-find-index-attname.md)
