---
message: "unrecognized window seek type: %d"
slug: unrecognized-window-seek-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3426"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3863"
  - "postgres/src/backend/executor/nodeWindowAgg.c:4155"
reproduced: false
---

# `unrecognized window seek type: %d`

## What it means

Internal error. Window-function execution reached a seek-type code it does not recognize while positioning within a window frame. The seek types are a fixed set, and this value matched none. It is a consistency check in the window executor.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in window-frame handling, not to your window query.

## How to fix

Treat it as an internal bug. Capture the query, including its `OVER (...)` clause, and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized window seek type.

```text
ERROR:  unrecognized window seek type: 4
```

## Related

- [aggregate order by is not implemented for window functions](./aggregate-order-by-is-not-implemented-for-window-functions.md)
- [unrecognized cmd type](./unrecognized-cmd-type.md)
