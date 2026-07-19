---
message: "cannot execute %s on a shared catalog"
slug: cannot-execute-on-a-shared-catalog
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:584"
reproduced: false
---

# `cannot execute %s on a shared catalog`

## What it means

A `REPACK` command targeted a shared system catalog. Shared catalogs are visible to every database in the cluster and this command is not supported against them. The placeholder is the command name.

## When it happens

It occurs when you run `REPACK` on a shared catalog such as `pg_database`, `pg_authid`, or `pg_shdepend`.

## How to fix

Do not target shared catalogs with this command. Choose a regular table, or use a maintenance path that supports shared catalogs where one exists.

## Example

*Illustrative* — a command run against a shared catalog.

```text
ERROR:  cannot execute REPACK on a shared catalog
```

## Related

- [cannot execute on multiple tables](./cannot-execute-on-multiple-tables.md)
- [cannot execute in this configuration](./cannot-execute-in-this-configuration.md)
