---
message: "invalid varattno %d"
slug: invalid-varattno
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:3555"
  - "postgres/src/backend/parser/parse_relation.c:3572"
reproduced: false
---

# `invalid varattno %d`

## What it means

Internal error. A `Var` node carried an attribute number that does not correspond to a column of its referenced range-table entry. The placeholder is the bad number. It is a consistency guard in the planner/executor.

## When it happens

It fires when expression evaluation or planning resolves a variable against a relation and the attribute number is out of range. Ordinary queries do not surface it; it points to an internal inconsistency, sometimes a stale cached plan after schema change.

## How to fix

This is a can't-happen guard. If it follows an `ALTER TABLE` with cached plans, reconnecting to force replanning can clear it. Capture the query and the table's current columns and report a reproducible case.

## Example

*Illustrative* — a Var referencing a nonexistent column position.

```text
ERROR:  invalid varattno 9
```

## Related

- [invalid attnum](./invalid-attnum.md)
- [invalid paramid](./invalid-paramid.md)
