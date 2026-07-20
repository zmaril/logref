---
message: "WHERE CURRENT OF on a view is not implemented"
slug: where-current-of-on-a-view-is-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:603"
  - "postgres/src/backend/parser/analyze.c:2879"
reproduced: false
---

# `WHERE CURRENT OF on a view is not implemented`

## What it means

A `WHERE CURRENT OF <cursor>` was used against a view, which PostgreSQL does not support because a view row does not have the stable physical identity cursor positioning relies on.

## When it happens

It arises from `UPDATE`/`DELETE ... WHERE CURRENT OF` when the cursor's query is over a view rather than a base table.

## How to fix

Position the cursor over a base table and use `WHERE CURRENT OF` there, or rewrite the update to match on the row's key columns instead of the cursor position.

## Example

*Illustrative* — WHERE CURRENT OF against a view.

```text
ERROR:  WHERE CURRENT OF on a view is not implemented
```

## Related

- [with check option is supported only on automatically updatable views](./with-check-option-is-supported-only-on-automatically-updatable-views.md)
- [window "%s" does not exist](./window-does-not-exist.md)
