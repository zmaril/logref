---
message: "cursor can only scan forward"
slug: cursor-can-only-scan-forward
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/tcop/pquery.c:934"
  - "postgres/src/backend/tcop/pquery.c:1679"
reproduced: false
---

# `cursor can only scan forward`

## What it means

A `FETCH`/`MOVE` asked a cursor to move backward, but the cursor does not support backward scans. Only cursors declared `SCROLL` (and over a plan that allows it) can move in reverse.

## When it happens

Using `FETCH BACKWARD`, `FETCH PRIOR`, or a negative `MOVE` on a `NO SCROLL` cursor, or on a `SCROLL` cursor whose plan cannot be scanned backward.

## How to fix

Declare the cursor `SCROLL` if you need backward motion, and ensure the query supports it (some plans, such as those with volatile functions, cannot). Otherwise fetch only forward.

## Example

*Illustrative* — fetching backward on a forward-only cursor.

```text
ERROR:  cursor can only scan forward
HINT:  Declare it with SCROLL option to enable backward scan.
```

## Related

- [cursor is not positioned on a row](./cursor-is-not-positioned-on-a-row.md)
- [cursor already in use](./cursor-already-in-use.md)
