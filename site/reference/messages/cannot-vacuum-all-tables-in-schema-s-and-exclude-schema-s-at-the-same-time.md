---
message: "cannot vacuum all tables in schema(s) and exclude schema(s) at the same time"
slug: cannot-vacuum-all-tables-in-schema-s-and-exclude-schema-s-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:343"
reproduced: false
---

# `cannot vacuum all tables in schema(s) and exclude schema(s) at the same time`

## What it means

`vacuumdb` was asked both to vacuum all tables in one or more schemas and to exclude one or more schemas in the same run. The include-schema and exclude-schema selections cannot be combined.

## When it happens

It occurs with `vacuumdb --schema` together with `--exclude-schema`.

## How to fix

Use one selection. Pick the schemas to vacuum with `--schema`, or vacuum broadly and exclude schemas with `--exclude-schema`, but not both together.

## Example

*Illustrative* — include and exclude schemas together.

```text
vacuumdb: error: cannot vacuum all tables in schema(s) and exclude schema(s) at the same time
```

## Related

- [cannot vacuum all tables in schema(s) and specific table(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-specific-table-s-at-the-same-time.md)
- [cannot vacuum specific table(s) and exclude schema(s) at the same time](./cannot-vacuum-specific-table-s-and-exclude-schema-s-at-the-same-time.md)
