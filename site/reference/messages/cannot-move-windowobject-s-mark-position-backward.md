---
message: "cannot move WindowObject's mark position backward"
slug: cannot-move-windowobject-s-mark-position-backward
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3740"
reproduced: false
---

# `cannot move WindowObject's mark position backward`

## What it means

An internal guard in the window-function executor fired: a window function tried to move its mark position to an earlier row. The mark only advances forward as the window releases rows behind it, so moving it backward is not allowed.

## When it happens

It is reached from a window support function that requests an earlier mark than the one already set. It reflects a coding issue in a window function rather than a user action.

## How to fix

There is no user-level fix. If it appears with a built-in window function, report it; if it appears with a custom window function from an extension, that function is moving the mark backward and needs correction.

## Example

*Illustrative* — a mark moved backward.

```text
ERROR:  cannot move WindowObject's mark position backward
```

## Related

- [cannot fetch row before WindowObject's mark position](./cannot-fetch-row-before-windowobject-s-mark-position.md)
- [cannot push down CurrentOfExpr](./cannot-push-down-currentofexpr.md)
