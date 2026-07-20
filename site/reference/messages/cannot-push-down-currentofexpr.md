---
message: "cannot push down CurrentOfExpr"
slug: cannot-push-down-currentofexpr
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteManip.c:817"
reproduced: false
---

# `cannot push down CurrentOfExpr`

## What it means

An internal guard in the query rewriter fired: it met a `CURRENT OF` cursor reference where it cannot be pushed down. A `WHERE CURRENT OF cursor` clause must stay attached to the scan of the cursor's table, and this context does not allow relocating it.

## When it happens

It is reached when rule rewriting or subquery handling would move a `CURRENT OF` expression into a place it cannot go. It reflects a coding issue or an unsupported use rather than a routine user action.

## How to fix

There is no user-level fix at the mechanism. Avoid `WHERE CURRENT OF` through views or rules that would relocate the reference; run the positioned update or delete directly against the base table the cursor scans.

## Example

*Illustrative* — a CURRENT OF reference that cannot move.

```text
ERROR:  cannot push down CurrentOfExpr
```

## Related

- [cannot move WindowObject's mark position backward](./cannot-move-windowobject-s-mark-position-backward.md)
- [cannot set parent params from subquery](./cannot-set-parent-params-from-subquery.md)
