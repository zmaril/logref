---
message: "cannot vacuum all tables in schema(s) and specific table(s) at the same time"
slug: cannot-vacuum-all-tables-in-schema-s-and-specific-table-s-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:335"
reproduced: false
---

# `cannot vacuum all tables in schema(s) and specific table(s) at the same time`

## What it means

`vacuumdb` was asked both to vacuum all tables in one or more schemas and to vacuum specific tables in the same run. The schema-wide and specific-table selections cannot be combined.

## When it happens

It occurs with `vacuumdb --schema` together with `--table`.

## How to fix

Use one selection. Vacuum whole schemas with `--schema`, or name individual tables with `--table`, and remove the conflicting option.

## Example

*Illustrative* — schema and table selections together.

```text
vacuumdb: error: cannot vacuum all tables in schema(s) and specific table(s) at the same time
```

## Related

- [cannot vacuum all tables in schema(s) and exclude schema(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-exclude-schema-s-at-the-same-time.md)
- [cannot vacuum all databases and a specific one at the same time](./cannot-vacuum-all-databases-and-a-specific-one-at-the-same-time.md)
