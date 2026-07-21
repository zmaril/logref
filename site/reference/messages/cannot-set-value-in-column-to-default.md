---
message: "cannot set value in column %d to DEFAULT"
slug: cannot-set-value-in-column-to-default
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1594"
reproduced: false
---

# `cannot set value in column %d to DEFAULT`

## What it means

An internal guard in the rewriter fired: it was asked to set a specific column to `DEFAULT` in a context where no default can be applied. The rewrite path reached a column-assignment it cannot fulfill with a default. The placeholder is the column number.

## When it happens

It is reached during query rewriting when a `DEFAULT` assignment lands on a column that has no applicable default in that context. It usually stems from a view or rule that maps `DEFAULT` onto a non-defaultable target.

## How to fix

Assign an explicit value rather than `DEFAULT` for that column, or adjust the view or rule so `DEFAULT` maps to a base column that has one. Avoid `DEFAULT` where the rewrite cannot supply it.

## Example

*Illustrative* — a DEFAULT that cannot be applied.

```text
ERROR:  cannot set value in column 2 to DEFAULT
```

## Related

- [cannot set a subfield to DEFAULT](./cannot-set-a-subfield-to-default.md)
- [cannot set an array element to DEFAULT](./cannot-set-an-array-element-to-default.md)
