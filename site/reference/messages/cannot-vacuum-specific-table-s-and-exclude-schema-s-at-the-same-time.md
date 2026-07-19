---
message: "cannot vacuum specific table(s) and exclude schema(s) at the same time"
slug: cannot-vacuum-specific-table-s-and-exclude-schema-s-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:339"
reproduced: false
---

# `cannot vacuum specific table(s) and exclude schema(s) at the same time`

## What it means

`vacuumdb` was asked both to vacuum specific tables and to exclude one or more schemas in the same run. Naming tables and excluding schemas describe conflicting scopes, so they cannot be combined.

## When it happens

It occurs with `vacuumdb --table` together with `--exclude-schema`.

## How to fix

Use one selection. Name the tables to vacuum with `--table`, or vacuum broadly and exclude schemas with `--exclude-schema`, but not both.

## Example

*Illustrative* — specific tables and excluded schemas together.

```text
vacuumdb: error: cannot vacuum specific table(s) and exclude schema(s) at the same time
```

## Related

- [cannot vacuum all tables in schema(s) and exclude schema(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-exclude-schema-s-at-the-same-time.md)
- [cannot vacuum all tables in schema(s) and specific table(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-specific-table-s-at-the-same-time.md)
