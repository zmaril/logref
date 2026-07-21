---
message: "unrecognized table_tuple_delete status: %u"
slug: unrecognized-table-tuple-delete-status
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/table/tableam.c:347"
  - "postgres/src/backend/executor/nodeModifyTable.c:2073"
reproduced: false
---

# `unrecognized table_tuple_delete status: %u`

## What it means

Internal error. The executor received a delete-result status from the table access method that is not one of the defined outcomes.

## When it happens

It fires where the result of a low-level tuple delete is switched on and the value is outside the known set. Ordinary `DELETE`/`UPDATE` does not produce it.

## How to fix

This is an internal guard over the table-AM contract. If it appears with the built-in heap AM, capture the statement and surrounding log and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized delete status.

```text
ERROR:  unrecognized table_tuple_delete status: 9
```

## Related

- [unrecognized table_tuple_update status: %u](./unrecognized-table-tuple-update-status.md)
- [unexpected operation: %d](./unexpected-operation.md)
