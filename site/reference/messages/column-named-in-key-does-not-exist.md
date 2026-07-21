---
message: "column \"%s\" named in key does not exist"
slug: column-named-in-key-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1974"
  - "postgres/src/backend/parser/parse_utilcmd.c:2739"
  - "postgres/src/backend/parser/parse_utilcmd.c:2928"
reproduced: false
---

# `column "%s" named in key does not exist`

## What it means

An index, constraint, or key definition referenced a column that the table does not have. The placeholder names the column. The columns listed in a key must exist on the table; a missing or misspelled one cannot be indexed or constrained.

## When it happens

Creating an index, primary key, unique constraint, or foreign key whose column list names a column that is misspelled, was dropped, or belongs to a different table.

## How to fix

Correct the column name to one that exists on the table (`\d tablename` lists them), or add the column first. Watch for case sensitivity when the column was created with a quoted, mixed-case identifier. Ensure you are defining the key on the right table.

## Example

*Illustrative* — indexing a nonexistent column.

```sql
CREATE INDEX ON t (nope);  -- column "nope" named in key does not exist
```

## Related

- [column not referenced by COPY](./column-not-referenced-by-copy.md)
- [attribute number exceeds number of columns](./attribute-number-exceeds-number-of-columns.md)
