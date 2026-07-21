---
message: "\"%s\" is not an existing enum label"
slug: is-not-an-existing-enum-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/pg_enum.c:416"
  - "postgres/src/backend/catalog/pg_enum.c:674"
reproduced: false
---

# `"%s" is not an existing enum label`

## What it means

An `ALTER TYPE ... ADD VALUE ... BEFORE/AFTER` (or `RENAME VALUE`) referenced an anchor label that does not exist in the enum. The placeholder is the missing label.

## When it happens

It arises when adding or renaming an enum value relative to another label that is misspelled or not part of the enum's current set.

## How to fix

Reference an existing label as the anchor. List the enum's labels with `SELECT enum_range(NULL::your_enum);` and use one of those exactly (labels are case-sensitive). Correct the anchor name and retry.

## Example

*Illustrative* — inserting relative to a nonexistent label.

```sql
ALTER TYPE mood ADD VALUE 'elated' AFTER 'joyus';  -- no label 'joyus'
```

## Related

- [is not an enum](./is-not-an-enum.md)
- [invalid input value for enum](./invalid-input-value-for-enum.md)
