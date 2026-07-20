---
message: "unrecognized table_tuple_update status: %u"
slug: unrecognized-table-tuple-update-status
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/table/tableam.c:396"
  - "postgres/src/backend/executor/nodeModifyTable.c:2988"
reproduced: false
---

# `unrecognized table_tuple_update status: %u`

## What it means

Internal error. The executor received an update-result status from the table access method that is not one of the defined outcomes.

## When it happens

It fires where the result of a low-level tuple update is switched on and the value is outside the known set. Ordinary `UPDATE` does not produce it.

## How to fix

This is an internal guard over the table-AM contract. If it appears with the built-in heap AM, capture the statement and surrounding log and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized update status.

```text
ERROR:  unrecognized table_tuple_update status: 9
```

## Related

- [unrecognized table_tuple_delete status: %u](./unrecognized-table-tuple-delete-status.md)
- [unexpected operation: %d](./unexpected-operation.md)
