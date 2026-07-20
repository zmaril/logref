---
message: "cannot copy from view \"%s\""
slug: cannot-copy-from-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyto.c:815"
reproduced: false
---

# `cannot copy from view "%s"`

## What it means

A `COPY ... TO` named a view as its source. `COPY` reads from a physical table, and a view is a stored query rather than stored rows. The placeholder is the view name.

## When it happens

It occurs when `COPY view TO ...` names a view directly.

## How to fix

Use `COPY (SELECT ... FROM view) TO ...` to export a view's rows through a query, or copy from the underlying table. `COPY` cannot take a view as a direct relation source.

## Example

*Illustrative* — COPY from a view.

```text
ERROR:  cannot copy from view "v"
```

## Related

- [cannot copy to view](./cannot-copy-to-view.md)
- [cannot copy from non-table relation](./cannot-copy-from-non-table-relation.md)
