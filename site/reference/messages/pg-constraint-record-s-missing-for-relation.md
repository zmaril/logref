---
message: "%d pg_constraint record(s) missing for relation \"%s\""
slug: pg-constraint-record-s-missing-for-relation
passthrough: false
api: [elog]
level: [ERROR, WARNING]
call_sites:
  - "postgres/src/backend/executor/execMain.c:1859"
  - "postgres/src/backend/utils/cache/relcache.c:4699"
reproduced: false
---

# `%d pg_constraint record(s) missing for relation "%s"`

## What it means

A consistency check found fewer `pg_constraint` catalog rows than a relation's other catalog state implies should exist. The placeholders are the missing count and the relation name. It reports catalog corruption or an incomplete constraint definition.

## When it happens

It surfaces during operations that reconcile a table's constraints against `pg_constraint` — for example while validating inheritance or partition constraint state — when expected constraint rows are absent. It can be reported as a warning during checks or as an error mid-operation.

## How to fix

Treat it as possible catalog inconsistency. Investigate with `amcheck` and by inspecting `pg_constraint` for the relation; restore from a known-good backup if corruption is confirmed. Capture the case for a bug report if no hardware/storage fault explains it.

## Example

*Illustrative* — a table missing expected constraint catalog rows.

```text
WARNING:  1 pg_constraint record(s) missing for relation "orders"
```

## Related

- [relation %u has non-inherited constraint "%s"](./relation-has-non-inherited-constraint.md)
- [referenced relation "%s" is not a table](./referenced-relation-is-not-a-table.md)
