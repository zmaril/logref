---
message: "cannot delete from foreign table \"%s\""
slug: cannot-delete-from-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1170"
reproduced: false
---

# `cannot delete from foreign table "%s"`

## What it means

A `DELETE` targeted a foreign table whose foreign-data wrapper does not support deletes. The remote side, or the wrapper's implementation, does not provide a delete path. The placeholder is the table name.

## When it happens

It occurs when deleting from a foreign table backed by a wrapper that lacks delete support, or is configured read-only.

## How to fix

Delete on the remote system directly if possible, or use a foreign-data wrapper and configuration that support deletes. Confirm the wrapper implements the modify routines for the operation you need.

## Example

*Illustrative* — deleting from a read-only foreign table.

```text
ERROR:  cannot delete from foreign table "f"
```

## Related

- [cannot delete from view using for portion of](./cannot-delete-from-view-using-for-portion-of.md)
- [cannot delete from table because it does not have a replica identity and](./cannot-delete-from-table-because-it-does-not-have-a-replica-identity-and.md)
