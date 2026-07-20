---
message: "tablespace \"%s\" does not exist"
slug: tablespace-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR, NOTICE]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:431"
  - "postgres/src/backend/commands/tablespace.c:959"
  - "postgres/src/backend/commands/tablespace.c:1054"
  - "postgres/src/backend/commands/tablespace.c:1123"
  - "postgres/src/backend/commands/tablespace.c:1269"
  - "postgres/src/backend/commands/tablespace.c:1472"
reproduced: false
---

# `tablespace "%s" does not exist`

## What it means

A command referred to a tablespace by name that is not registered in the cluster. The placeholder is the name. Tablespaces are cluster-wide objects in `pg_tablespace`; naming one that was never created, or was dropped, produces this. At `NOTICE` it is the harmless `IF EXISTS` form.

## When it happens

Creating or moving an object `TABLESPACE foo`, running `ALTER ... SET TABLESPACE foo`, or `DROP TABLESPACE foo` when `foo` does not exist. The `NOTICE` variant is emitted by `DROP TABLESPACE IF EXISTS` on a missing name.

## How to fix

List existing tablespaces with `\db` in psql or `SELECT spcname FROM pg_tablespace`. Create the tablespace first with `CREATE TABLESPACE foo LOCATION '/path'`, or correct the name to one that exists. For a `DROP`, use `IF EXISTS` if a missing tablespace should be tolerated.

## Example

*Illustrative* — placing a table in a missing tablespace.

```sql
CREATE TABLE t (id int) TABLESPACE nowhere;
```

## Related

- [server does not exist](./server-does-not-exist.md)
- [access method does not exist](./access-method-does-not-exist.md)
