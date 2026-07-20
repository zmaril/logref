---
message: "cannot copy to view \"%s\""
slug: cannot-copy-to-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:823"
reproduced: false
---

# `cannot copy to view "%s"`

## What it means

A `COPY ... FROM` named a view as its target. A view is a stored query, not stored rows, so `COPY FROM` cannot load into it directly. The placeholder is the view name.

## When it happens

It occurs when `COPY view FROM ...` names a view.

## How to fix

Define an `INSTEAD OF INSERT` trigger on the view and load through it, or copy into the underlying table. `COPY FROM` writes only to base tables.

## Example

*Illustrative* — COPY into a view.

```text
ERROR:  cannot copy to view "v"
```

## Related

- [cannot copy from view](./cannot-copy-from-view.md)
- [cannot copy to materialized view](./cannot-copy-to-materialized-view.md)
