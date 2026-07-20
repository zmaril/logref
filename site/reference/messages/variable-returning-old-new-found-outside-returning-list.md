---
message: "variable returning old/new found outside RETURNING list"
slug: variable-returning-old-new-found-outside-returning-list
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/setrefs.c:3190"
  - "postgres/src/backend/rewrite/rewriteManip.c:1916"
reproduced: false
---

# `variable returning old/new found outside RETURNING list`

## What it means

A reference to the `OLD` or `NEW` transition rows appeared in a part of a data-modifying statement where those references are only valid inside the `RETURNING` list.

## When it happens

It arises with the newer `OLD`/`NEW` support in `RETURNING` when such a reference leaks into another clause of the statement — outside the `RETURNING` list where transition rows are resolved.

## How to fix

Reference `OLD`/`NEW` only within the `RETURNING` list. Move the expression using them into `RETURNING`, or restructure the statement so the transition-row reference sits where it is allowed.

## Example

*Illustrative* — an OLD/NEW reference outside RETURNING.

```text
ERROR:  variable returning old/new found outside RETURNING list
```

## Related

- [unexpected return value from trigger procedure](./unexpected-return-value-from-trigger-procedure.md)
- [WHERE CURRENT OF on a view is not implemented](./where-current-of-on-a-view-is-not-implemented.md)
