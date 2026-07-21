---
message: "cannot vacuum all databases and a specific one at the same time"
slug: cannot-vacuum-all-databases-and-a-specific-one-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:331"
reproduced: true
---

# `cannot vacuum all databases and a specific one at the same time`

## What it means

`vacuumdb` was asked to vacuum every database and also a specific one in the same run. Those selections are mutually exclusive, so the tool cannot honor both at once.

## When it happens

It occurs with `vacuumdb --all` combined with `--dbname` or a positional database name.

## How to fix

Choose one scope. Use `--all` to vacuum every database, or name a single database, and remove the conflicting option.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  cannot vacuum all databases and a specific one at the same time
```

## Related

- [cannot vacuum all tables in schema(s) and specific table(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-specific-table-s-at-the-same-time.md)
- [cannot vacuum all tables in schema(s) and exclude schema(s) at the same time](./cannot-vacuum-all-tables-in-schema-s-and-exclude-schema-s-at-the-same-time.md)
