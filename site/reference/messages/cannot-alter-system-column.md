---
message: "cannot alter system column \"%s\""
slug: cannot-alter-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7918"
  - "postgres/src/backend/commands/tablecmds.c:8085"
  - "postgres/src/backend/commands/tablecmds.c:8286"
  - "postgres/src/backend/commands/tablecmds.c:8417"
  - "postgres/src/backend/commands/tablecmds.c:8571"
  - "postgres/src/backend/commands/tablecmds.c:8665"
  - "postgres/src/backend/commands/tablecmds.c:8768"
  - "postgres/src/backend/commands/tablecmds.c:8958"
  - "postgres/src/backend/commands/tablecmds.c:9124"
  - "postgres/src/backend/commands/tablecmds.c:9215"
  - "postgres/src/backend/commands/tablecmds.c:9349"
  - "postgres/src/backend/commands/tablecmds.c:14952"
  - "postgres/src/backend/commands/tablecmds.c:16711"
  - "postgres/src/backend/commands/tablecmds.c:19476"
reproduced: true
---

# `cannot alter system column "%s"`

## What it means

An `ALTER TABLE` tried to change a system column — one of the hidden columns every table has (`ctid`, `xmin`, `xmax`, `cmin`, `cmax`, `tableoid`). The placeholder is the column name. System columns are managed by the storage engine and cannot be altered.

## When it happens

Attempting `ALTER TABLE ... ALTER COLUMN ctid ...` or otherwise targeting a system column with DDL. Sometimes a tool or migration accidentally includes a system column name.

## How to fix

Do not alter system columns — they are part of the row storage machinery. If you wanted a user column, check the name; a typo may have matched a system column. There is no supported way to change these columns.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER TABLE s37.dep ALTER COLUMN xmin TYPE text;
```

Produces:

```text
ERROR:  cannot alter system column "xmin"
```

## Related

- [cannot convert whole-row table reference](./cannot-convert-whole-row-table-reference.md)
- [column of relation does not exist](./column-of-relation-does-not-exist-7bb9c5.md)
