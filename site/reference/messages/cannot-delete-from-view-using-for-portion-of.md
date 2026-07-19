---
message: "cannot delete from view \"%s\" using FOR PORTION OF \"%s\""
slug: cannot-delete-from-view-using-for-portion-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3516"
reproduced: false
---

# `cannot delete from view "%s" using FOR PORTION OF "%s"`

## What it means

A `DELETE ... FOR PORTION OF` targeted a view. The temporal `FOR PORTION OF` clause operates on a table's period columns, and a view does not provide the storage that portion-based deletion needs. The placeholders are the view and period names.

## When it happens

It occurs when a temporal `DELETE ... FOR PORTION OF period` names a view rather than a base table.

## How to fix

Run the `FOR PORTION OF` delete against the underlying base table with the period, not the view. Views cannot be the target of portion-based temporal operations.

## Example

*Illustrative* — portion delete on a view.

```text
ERROR:  cannot delete from view "v" using FOR PORTION OF "p"
```

## Related

- [cannot delete from foreign table](./cannot-delete-from-foreign-table.md)
- [cannot copy to view](./cannot-copy-to-view.md)
