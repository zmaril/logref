---
message: "unacceptable schema name \"%s\""
slug: unacceptable-schema-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_RESERVED_NAME
    code: "42939"
call_sites:
  - "postgres/src/backend/commands/schemacmds.c:107"
  - "postgres/src/backend/commands/schemacmds.c:288"
reproduced: false
---

# `unacceptable schema name "%s"`

## What it means

A schema name was rejected because it uses a reserved prefix. The placeholder is the name. Names beginning with `pg_` are reserved for system use, so user schemas cannot use that prefix.

## When it happens

It arises from `CREATE SCHEMA pg_something` (or an equivalent), where the name intrudes on the reserved `pg_` namespace.

## How to fix

Choose a schema name that does not begin with `pg_`. That prefix is reserved for system schemas; pick an application-specific name instead.

## Example

*Illustrative* — a schema name using the reserved prefix.

```text
ERROR:  unacceptable schema name "pg_reports"
DETAIL:  The prefix "pg_" is reserved for system schemas.
```

## Related

- [schema "%s" already exists](./schema-already-exists.md)
- [unacceptable tablespace name "%s"](./unacceptable-tablespace-name.md)
