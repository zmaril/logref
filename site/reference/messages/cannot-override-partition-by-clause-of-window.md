---
message: "cannot override PARTITION BY clause of window \"%s\""
slug: cannot-override-partition-by-clause-of-window
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WINDOWING_ERROR
    code: "42P20"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3060"
reproduced: true
---

# `cannot override PARTITION BY clause of window "%s"`

## What it means

A window reference tried to add a `PARTITION BY` clause to a named window. A reference to a named window inherits its partitioning and cannot supply its own. The placeholder is the window name.

## When it happens

It occurs when a query references a named window with `OVER w` and also gives a `PARTITION BY` in the `OVER (...)`.

## How to fix

Use the named window without adding `PARTITION BY`, or define a distinct window with the partitioning you want. A window reference cannot restate the base window's partitioning.

## Example

*Reproduced* — captured from `reproducers/scenarios/38_planner_executor_runtime.sql`.

```sql
SELECT sum(id) OVER (w PARTITION BY id) FROM repro.parent WINDOW w AS (PARTITION BY label);
```

Produces:

```text
ERROR:  cannot override PARTITION BY clause of window "w"
```

## Related

- [cannot override ORDER BY clause of window](./cannot-override-order-by-clause-of-window.md)
- [cannot move WindowObject's mark position backward](./cannot-move-windowobject-s-mark-position-backward.md)
