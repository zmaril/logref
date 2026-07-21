---
message: "cannot fetch row before WindowObject's mark position"
slug: cannot-fetch-row-before-windowobject-s-mark-position
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3274"
reproduced: false
---

# `cannot fetch row before WindowObject's mark position`

## What it means

An internal guard in the window-function executor fired: a window function asked for a row that lies before the window's mark position. Once the executor marks a position, earlier rows may have been discarded, so they can no longer be fetched.

## When it happens

It is reached from a window support function that requests a row the framing logic has already released. It reflects a coding issue in a window function rather than a user action.

## How to fix

There is no user-level fix. If it appears with a built-in window function, report it; if it appears with a custom window function from an extension, that function is fetching rows behind the mark and needs correction.

## Example

*Illustrative* — a fetch behind the mark position.

```text
ERROR:  cannot fetch row before WindowObject's mark position
```

## Related

- [cannot execute SQL without an outer snapshot or portal](./cannot-execute-sql-without-an-outer-snapshot-or-portal.md)
- [cannot handle unplanned sub-select](./cannot-handle-unplanned-sub-select.md)
