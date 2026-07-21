---
message: "ginarrayconsistent: unknown strategy number: %d"
slug: ginarrayconsistent-unknown-strategy-number
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/ginarrayproc.c:218"
  - "postgres/src/backend/access/gin/ginarrayproc.c:305"
reproduced: false
---

# `ginarrayconsistent: unknown strategy number: %d`

## What it means

Internal error in the GIN array operator class. Its consistency function received a strategy number it does not recognize. The `%d` is the strategy. It is a support-function guard.

## When it happens

It fires when a query drove the GIN array opclass with an unexpected strategy — normally impossible through built-in operators. It can indicate a broken or mismatched operator-class definition.

## How to fix

This is a can't-happen guard. If a custom or altered operator class is involved, suspect it. Capture the query and the operator/opclass and report a reproducible case.

## Example

*Illustrative* — an unknown GIN array strategy.

```text
ERROR:  ginarrayconsistent: unknown strategy number: 9
```

## Related

- [failed to add item to index page](./failed-to-add-item-to-index-page.md)
- [inconsistent point values](./inconsistent-point-values.md)
