---
message: "\"%s\" is not a materialized view"
slug: is-not-a-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1489"
  - "postgres/src/backend/commands/matview.c:198"
  - "postgres/src/backend/commands/tablecmds.c:20384"
reproduced: false
---

# `"%s" is not a materialized view`

## What it means

A command that only applies to materialized views was pointed at something else. `REFRESH MATERIALIZED VIEW` and related operations require a materialized view, and the named object is a plain table, an ordinary view, or another relation kind.

## When it happens

Running `REFRESH MATERIALIZED VIEW` or another materialized-view-only command against a name that resolves to a regular view or a table.

## How to fix

Confirm the object is actually a materialized view (`\dm` in psql lists them). If you meant a plain view, it does not need refreshing, since it is evaluated on every read. If you want cached results you can refresh, define the object with `CREATE MATERIALIZED VIEW`.

## Example

*Illustrative* — refreshing something that is not a materialized view.

```sql
REFRESH MATERIALIZED VIEW plain_view;  -- "plain_view" is not a materialized view
```

## Related

- [is not a view](./is-not-a-view-960471.md)
- [is a view](./is-a-view.md)
