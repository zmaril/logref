---
message: "tableoid is NULL"
slug: tableoid-is-null
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeLockRows.c:102"
  - "postgres/src/backend/executor/nodeModifyTable.c:4777"
reproduced: false
---

# `tableoid is NULL`

## What it means

Internal error. Code that expected a row's `tableoid` system column to identify its source table found it null. `tableoid` is normally always populated for a real heap tuple, so a null indicates an inconsistent tuple or slot.

## When it happens

It fires from execution paths (for example partition routing or trigger handling) that rely on `tableoid` to locate the owning relation, when the value is unexpectedly null. Ordinary queries do not produce it.

## How to fix

This is an internal consistency guard. If a real operation triggers it, capture the statement (especially involving partitions, foreign tables, or custom scans) and report it as a reproducible bug.

## Example

*Illustrative* — a tuple whose tableoid is unexpectedly null.

```text
ERROR:  tableoid is NULL
```

## Related

- [system-column update is not supported](./system-column-update-is-not-supported.md)
- [trying to store an on-disk heap tuple into wrong type of slot](./trying-to-store-an-on-disk-heap-tuple-into-wrong-type-of-slot.md)
