---
message: "cannot copy from foreign table \"%s\""
slug: cannot-copy-from-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyto.c:830"
  - "postgres/src/backend/commands/copyto.c:856"
reproduced: false
---

# `cannot copy from foreign table "%s"`

## What it means

`COPY ... TO` was pointed at a foreign table as its source. The placeholder is the table name. `COPY` reads and writes local heap storage, and a foreign table has none, so it cannot be a `COPY` source.

## When it happens

Running `COPY foreign_tbl TO ...` (or `COPY foreign_tbl TO STDOUT`) directly on a foreign table.

## How to fix

Use a query instead: `COPY (SELECT * FROM foreign_tbl) TO ...` reads through the foreign-data wrapper and copies the result out. `COPY table TO` only works on local tables.

## Example

*Illustrative* — copying directly from a foreign table.

```sql
COPY remote_orders TO STDOUT;
-- ERROR:  cannot copy from foreign table "remote_orders"
```

## Related

- [cannot copy to/from client in PL/pgSQL](./cannot-copy-to-from-client-in-pl-pgsql.md)
- [cache lookup failed for foreign server](./cache-lookup-failed-for-foreign-server.md)
