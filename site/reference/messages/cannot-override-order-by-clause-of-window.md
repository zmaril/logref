---
message: "cannot override ORDER BY clause of window \"%s\""
slug: cannot-override-order-by-clause-of-window
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WINDOWING_ERROR
    code: "42P20"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3072"
reproduced: false
---

# `cannot override ORDER BY clause of window "%s"`

## What it means

A window reference tried to add or replace an `ORDER BY` clause on a named window that already defines one. A window defined in the `WINDOW` clause fixes its ordering, and a reference to it cannot override that. The placeholder is the window name.

## When it happens

It occurs when a query names a window with `OVER w` and also supplies an `ORDER BY` in the `OVER (...)` while the named window `w` already has its own `ORDER BY`.

## How to fix

Either use the named window as-is without an added `ORDER BY`, or define a separate window with the ordering you need. A reference may extend a window only where the base window leaves that part unspecified.

## Example

*Illustrative* — overriding a named window's ordering.

```text
ERROR:  cannot override ORDER BY clause of window "w"
```

## Related

- [cannot override PARTITION BY clause of window](./cannot-override-partition-by-clause-of-window.md)
- [cannot move WindowObject's mark position backward](./cannot-move-windowobject-s-mark-position-backward.md)
