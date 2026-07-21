---
message: "only shared relations can be placed in pg_global tablespace"
slug: only-shared-relations-can-be-placed-in-pg-global-tablespace
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:830"
  - "postgres/src/backend/commands/tablecmds.c:976"
  - "postgres/src/backend/commands/tablecmds.c:3797"
  - "postgres/src/backend/commands/tablecmds.c:23293"
reproduced: true
---

# `only shared relations can be placed in pg_global tablespace`

## What it means

An attempt was made to put an ordinary (per-database) relation into the `pg_global` tablespace. `pg_global` is reserved for the shared system catalogs that every database sees; ordinary tables, indexes, and non-shared catalogs must live in a regular tablespace.

## When it happens

Specifying `TABLESPACE pg_global` on a `CREATE TABLE`/`CREATE INDEX`, or setting it as a default tablespace and then creating a normal object.

## How to fix

Choose a different tablespace: use `pg_default`, omit the `TABLESPACE` clause, or name a tablespace you created for the purpose. `pg_global` is not selectable for user objects — nothing you can do makes an ordinary relation valid there.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER TABLE s37.dep SET TABLESPACE pg_global;
```

Produces:

```text
ERROR:  only shared relations can be placed in pg_global tablespace
```

## Related

- [cannot specify default tablespace for partitioned relations](./cannot-specify-default-tablespace-for-partitioned-relations.md)
- [tablespace with OID does not exist](./tablespace-with-oid-does-not-exist.md)
