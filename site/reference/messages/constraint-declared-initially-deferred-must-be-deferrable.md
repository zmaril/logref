---
message: "constraint declared INITIALLY DEFERRED must be DEFERRABLE"
slug: constraint-declared-initially-deferred-must-be-deferrable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4265"
  - "postgres/src/backend/parser/parse_utilcmd.c:4291"
reproduced: false
---

# `constraint declared INITIALLY DEFERRED must be DEFERRABLE`

## What it means

A constraint was declared `INITIALLY DEFERRED` without also being `DEFERRABLE`. A constraint can only start out deferred if it is allowed to be deferred at all, so the two clauses must go together.

## When it happens

Writing a constraint definition with `INITIALLY DEFERRED` but omitting `DEFERRABLE`, in a `CREATE TABLE`, `ALTER TABLE`, or `CREATE DOMAIN`.

## How to fix

Add `DEFERRABLE` before `INITIALLY DEFERRED` (`DEFERRABLE INITIALLY DEFERRED`), or drop `INITIALLY DEFERRED` if the constraint should be checked immediately. A deferred constraint must be declared deferrable.

## Example

*Illustrative* — INITIALLY DEFERRED without DEFERRABLE.

```sql
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (a) REFERENCES p(id) INITIALLY DEFERRED;
-- ERROR:  constraint declared INITIALLY DEFERRED must be DEFERRABLE
```

## Related

- [conflicting NULL/NOT NULL constraints](./conflicting-null-not-null-constraints.md)
- [constraint for table does not exist](./constraint-for-table-does-not-exist.md)
