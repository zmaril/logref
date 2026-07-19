---
message: "unrecognized frame option state: 0x%x"
slug: unrecognized-frame-option-state-0x
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:4078"
  - "postgres/src/backend/executor/nodeWindowAgg.c:4148"
reproduced: false
---

# `unrecognized frame option state: 0x%x`

## What it means

Internal error. Window-function framing code met a bitmask of frame options (the `ROWS`/`RANGE`/`GROUPS` and bound flags) that does not correspond to a valid combination.

## When it happens

It fires where a window frame's option bits are interpreted and the combination is outside the defined set. A valid `WINDOW`/`OVER` clause does not produce it.

## How to fix

This is an internal guard. If a real window query triggers it, capture the query and the frame clause and report it as a reproducible bug.

## Example

*Illustrative* — an invalid frame-option state.

```text
ERROR:  unrecognized frame option state: 0x00
```

## Related

- [window function calls cannot be nested](./window-function-calls-cannot-be-nested.md)
- [WINDOW_SEEK_CURRENT is not supported for WinGetFuncArgInFrame](./window-seek-current-is-not-supported-for-wingetfuncarginframe.md)
