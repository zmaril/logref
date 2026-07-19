---
message: "cannot modify statistics on system column \"%s\""
slug: cannot-modify-statistics-on-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/statistics/attribute_stats.c:226"
reproduced: false
---

# `cannot modify statistics on system column "%s"`

## What it means

A statistics-setting function targeted a system column such as `ctid` or `xmin`. System columns are maintained by the engine and have no user-adjustable planner statistics. The placeholder is the column name.

## When it happens

It occurs when a manual-statistics or statistics-import function names a hidden system column rather than a user column.

## How to fix

Set statistics only on user-defined columns. Remove the system column from the request, and let the engine manage system-column bookkeeping.

## Example

*Illustrative* — setting statistics on a system column.

```text
ERROR:  cannot modify statistics on system column "ctid"
```

## Related

- [cannot modify statistics for relation](./cannot-modify-statistics-for-relation.md)
- [cannot modify statistics for shared relation](./cannot-modify-statistics-for-shared-relation.md)
