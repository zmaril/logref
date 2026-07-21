---
message: "cursor \"%s\" is held from a previous transaction"
slug: cursor-is-held-from-a-previous-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:83"
reproduced: false
---

# `cursor "%s" is held from a previous transaction`

## What it means

An `UPDATE` or `DELETE ... WHERE CURRENT OF` was attempted against a held cursor left over from an earlier transaction. A `WITH HOLD` cursor survives its transaction but detaches from the live row locks a positioned update needs. The server reports it as an invalid cursor state.

## When it happens

It happens when you use `WHERE CURRENT OF` on a cursor declared `WITH HOLD` after its declaring transaction committed.

## How to fix

Positioned updates require a cursor within the same transaction that holds the row locks. Declare a non-held cursor with `FOR UPDATE` in the current transaction and perform the update there. Held cursors are for reading across transactions, not for `WHERE CURRENT OF`.

## Example

*Illustrative* — CURRENT OF on a held cursor.

```text
ERROR:  cursor "c" is held from a previous transaction
```

## Related

- [cursor does not have a FOR UPDATE/SHARE reference to table](./cursor-does-not-have-a-for-update-share-reference-to-table.md)
- [DECLARE CURSOR WITH HOLD is not supported](./declare-cursor-with-hold-is-not-supported.md)
