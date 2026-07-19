---
message: "cannot assign to system column \"%s\""
slug: cannot-assign-to-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:486"
  - "postgres/src/backend/parser/parse_target.c:801"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5346"
reproduced: false
---

# `cannot assign to system column "%s"`

## What it means

An `INSERT` or `UPDATE` tried to write a value into a system column (such as `ctid`, `xmin`, `xmax`, `cmin`, `cmax`, or `tableoid`). The placeholder names the column. System columns are maintained by the storage engine and cannot be set by DML.

## When it happens

Listing a system column as an assignment target — for example `UPDATE t SET ctid = ...` or including a system column in an `INSERT` column list.

## How to fix

Remove the system column from the assignment. If you need a user-controllable identifier, add an ordinary column (a serial, identity, or UUID) and write to that instead. System columns are read-only by design.

## Example

*Illustrative* — assigning to a system column.

```sql
UPDATE t SET xmin = 0;  -- cannot assign to system column "xmin"
```

## Related

- [column of relation is an identity column](./column-of-relation-is-an-identity-column.md)
- [cannot update table](./cannot-update-table.md)
