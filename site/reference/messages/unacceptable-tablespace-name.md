---
message: "unacceptable tablespace name \"%s\""
slug: unacceptable-tablespace-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_RESERVED_NAME
    code: "42939"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:289"
  - "postgres/src/backend/commands/tablespace.c:976"
reproduced: false
---

# `unacceptable tablespace name "%s"`

## What it means

A tablespace name was rejected because it uses a reserved prefix. The placeholder is the name. Names beginning with `pg_` are reserved for system tablespaces.

## When it happens

It arises from `CREATE TABLESPACE pg_something`, intruding on the reserved `pg_` namespace.

## How to fix

Choose a tablespace name that does not begin with `pg_`. Reserve that prefix for the system's built-in tablespaces and pick a descriptive application name instead.

## Example

*Illustrative* — a tablespace name using the reserved prefix.

```text
ERROR:  unacceptable tablespace name "pg_fast"
DETAIL:  The prefix "pg_" is reserved for system tablespaces.
```

## Related

- [unacceptable schema name "%s"](./unacceptable-schema-name.md)
- [tablespace "%s" already exists](./tablespace-already-exists.md)
