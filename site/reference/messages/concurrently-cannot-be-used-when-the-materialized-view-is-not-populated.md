---
message: "CONCURRENTLY cannot be used when the materialized view is not populated"
slug: concurrently-cannot-be-used-when-the-materialized-view-is-not-populated
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/matview.c:205"
reproduced: true
---

# `CONCURRENTLY cannot be used when the materialized view is not populated`

## What it means

`REFRESH MATERIALIZED VIEW CONCURRENTLY` was run on a materialized view that has never been populated. A concurrent refresh updates existing contents in place, so it needs an already-populated view to work from.

## When it happens

It happens when a materialized view was created `WITH NO DATA` (or otherwise left unpopulated) and is then refreshed with `CONCURRENTLY`.

## How to fix

Run a plain `REFRESH MATERIALIZED VIEW` (without `CONCURRENTLY`) first to populate it, after which concurrent refreshes will work. Concurrent refresh also requires a unique index on the view.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY repro.mv2;
```

Produces:

```text
ERROR:  CONCURRENTLY cannot be used when the materialized view is not populated
```

## Related

- [concurrent index creation on system catalog tables is not supported](./concurrent-index-creation-on-system-catalog-tables-is-not-supported.md)
- [CONCURRENTLY option not supported for](./concurrently-option-not-supported-for.md)
