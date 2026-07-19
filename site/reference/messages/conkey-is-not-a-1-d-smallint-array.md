---
message: "conkey is not a 1-D smallint array"
slug: conkey-is-not-a-1-d-smallint-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:717"
  - "postgres/src/backend/catalog/pg_constraint.c:1311"
  - "postgres/src/backend/catalog/pg_constraint.c:1508"
  - "postgres/src/backend/catalog/pg_constraint.c:1559"
reproduced: false
---

# `conkey is not a 1-D smallint array`

## What it means

Internal error. Code read a constraint's `conkey` column (the list of constrained column numbers in `pg_constraint`) and it was not the expected one-dimensional `smallint[]`. It is a consistency check on catalog data shape.

## When it happens

It should not occur for normally-created constraints. Reaching it points to catalog corruption in `pg_constraint` or a bug, not to your SQL.

## How to fix

Treat it as an internal bug or catalog corruption. If it recurs on a specific table, inspect that table's `pg_constraint` rows; a malformed `conkey` indicates corruption warranting investigation and possibly recreating the constraint or restoring.

## Example

*Illustrative* — emitted internally reading a constraint.

```text
ERROR:  conkey is not a 1-D smallint array
```

## Related

- [constraint of relation does not exist](./constraint-of-relation-does-not-exist.md)
- [extconfig and extcondition arrays do not match](./extconfig-and-extcondition-arrays-do-not-match.md)
