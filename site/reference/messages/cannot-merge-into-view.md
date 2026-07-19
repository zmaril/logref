---
message: "cannot merge into view \"%s\""
slug: cannot-merge-into-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3544"
reproduced: false
---

# `cannot merge into view "%s"`

## What it means

A `MERGE` statement targeted a view that is not updatable for the merge. The view lacks the structure needed to apply inserts, updates, or deletes through it, so `MERGE` is rejected. The placeholder is the view name.

## When it happens

It occurs when a `MERGE` runs against a view that is not auto-updatable or has no `INSTEAD OF` triggers to handle the merge actions.

## How to fix

Run the `MERGE` against the base table, make the view auto-updatable, or add `INSTEAD OF INSERT/UPDATE/DELETE` triggers that define how each merge action should be applied.

## Example

*Illustrative* — MERGE into a non-updatable view.

```text
ERROR:  cannot merge into view "v_orders"
```

## Related

- [cannot merge into column of view](./cannot-merge-into-column-of-view.md)
- [cannot insert into column of view](./cannot-insert-into-column-of-view.md)
