---
message: "could not create exclusion constraint \"%s\""
slug: could-not-create-exclusion-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXCLUSION_VIOLATION
    code: "23P01"
call_sites:
  - "postgres/src/backend/executor/execIndexing.c:919"
reproduced: false
---

# `could not create exclusion constraint "%s"`

## What it means

Building an exclusion constraint failed because existing rows already violate the exclusion rule. The `%s` names the constraint. Two or more rows conflict under the constraint's operators, so it cannot be enforced.

## When it happens

It happens during `ALTER TABLE ADD CONSTRAINT ... EXCLUDE` or `CREATE TABLE` with an exclusion constraint, when the current data contains a pair of rows that the constraint would forbid.

## How to fix

Find and resolve the conflicting rows before adding the constraint. A follow-on detail line names a conflicting key. Remove or adjust the overlapping rows, then add the constraint again.

## Example

*Illustrative* — existing rows overlapping under the exclusion rule.

```sql
ALTER TABLE room_booking ADD CONSTRAINT no_overlap EXCLUDE USING gist (room WITH =, during WITH &&);
-- ERROR:  could not create exclusion constraint "no_overlap"
```

## Related

- [could not create unique index](./could-not-create-unique-index.md)
- [could not convert type to](./could-not-convert-type-to.md)
