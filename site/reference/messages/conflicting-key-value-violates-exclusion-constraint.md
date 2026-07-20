---
message: "conflicting key value violates exclusion constraint \"%s\""
slug: conflicting-key-value-violates-exclusion-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXCLUSION_VIOLATION
    code: "23P01"
call_sites:
  - "postgres/src/backend/executor/execIndexing.c:930"
reproduced: false
---

# `conflicting key value violates exclusion constraint "%s"`

## What it means

A row being inserted or updated conflicts with an existing row under an exclusion constraint. The constraint forbids two rows whose values overlap by its operator (for example overlapping time ranges), and this row would create such an overlap.

## When it happens

It happens on `INSERT` or `UPDATE` into a table with an `EXCLUDE` constraint when the new row overlaps an existing one according to the constraint's operators.

## How to fix

Adjust the row's values so they no longer overlap any existing row, or reconcile the conflicting existing row first. For time-range data, narrow or shift the range; for spatial data, ensure regions do not overlap.

## Example

*Illustrative* — an overlap under an exclusion constraint.

```sql
CREATE TABLE room (id int, during tstzrange,
  EXCLUDE USING gist (id WITH =, during WITH &&));
-- two overlapping reservations for the same room:
-- ERROR:  conflicting key value violates exclusion constraint "room_id_during_excl"
```

## Related

- [constraint in ON CONFLICT clause has no associated index](./constraint-in-on-conflict-clause-has-no-associated-index.md)
- [constraint is not deferrable](./constraint-is-not-deferrable.md)
