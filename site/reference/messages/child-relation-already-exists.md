---
message: "child relation already exists"
slug: child-relation-already-exists
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/relnode.c:167"
reproduced: false
---

# `child relation already exists`

## What it means

An internal guard fired while building an inheritance or partition relationship: the code tried to record a child relation that was already registered as a child of the same parent. The bookkeeping expects each child once, so this state should not occur.

## When it happens

It is reached from inheritance or partition setup in the server. It reflects an internal inconsistency rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the DDL that led to it, the table hierarchy, and the server log, then report it. It points to a bug or catalog inconsistency.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  child relation already exists
```

## Related

- [child table is missing column](./child-table-is-missing-column.md)
- [child table is missing constraint](./child-table-is-missing-constraint.md)
