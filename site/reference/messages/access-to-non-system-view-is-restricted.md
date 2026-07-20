---
message: "access to non-system view \"%s\" is restricted"
slug: access-to-non-system-view-is-restricted
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1781"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3363"
reproduced: false
---

# `access to non-system view "%s" is restricted`

## What it means

An operation that is only permitted against system views was attempted on a user-defined view. The restricted code path allows reading system catalog views but refuses to extend the same access to ordinary views, for safety.

## When it happens

A context that expands or reads a view under restricted rules encountered a non-system view where only system views are allowed — for example certain internal rewrite paths that treat user views differently from catalog views.

## How to fix

Rework the operation so it does not require restricted access to a user view. If a view is standing in for data you can query directly, query the underlying tables or a system view instead. The restriction is a safety boundary, so the fix is to avoid crossing it rather than to widen it.

## Example

*Illustrative* — restricted access reaching a user view.

```text
ERROR:  access to non-system view "my_view" is restricted
```

## Related

- [is a view](./is-a-view.md)
- [permission denied](./permission-denied.md)
