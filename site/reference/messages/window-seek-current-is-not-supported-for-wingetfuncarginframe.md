---
message: "WINDOW_SEEK_CURRENT is not supported for WinGetFuncArgInFrame"
slug: window-seek-current-is-not-supported-for-wingetfuncarginframe
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3404"
  - "postgres/src/backend/executor/nodeWindowAgg.c:4019"
reproduced: false
---

# `WINDOW_SEEK_CURRENT is not supported for WinGetFuncArgInFrame`

## What it means

Internal error. A window-function support routine asked to fetch a frame argument relative to the current row using a seek mode the frame-access helper does not implement.

## When it happens

It fires from custom or built-in window-function support code that calls the frame-argument helper with an unsupported seek mode. Ordinary window queries do not reach it.

## How to fix

This is an internal guard aimed at window-function implementations. If a custom window function triggers it, use a supported seek mode; if only built-in functions are involved, capture the query and report it.

## Example

*Illustrative* — an unsupported frame seek mode.

```text
ERROR:  WINDOW_SEEK_CURRENT is not supported for WinGetFuncArgInFrame
```

## Related

- [unrecognized frame option state: 0x%x](./unrecognized-frame-option-state-0x.md)
- [window function calls cannot be nested](./window-function-calls-cannot-be-nested.md)
