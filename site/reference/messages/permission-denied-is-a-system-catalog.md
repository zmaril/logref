---
message: "permission denied: \"%s\" is a system catalog"
slug: permission-denied-is-a-system-catalog
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/policy.c:96"
  - "postgres/src/backend/commands/policy.c:389"
  - "postgres/src/backend/commands/repack.c:635"
  - "postgres/src/backend/commands/statscmds.c:166"
  - "postgres/src/backend/commands/tablecmds.c:1871"
  - "postgres/src/backend/commands/tablecmds.c:2476"
  - "postgres/src/backend/commands/tablecmds.c:3924"
  - "postgres/src/backend/commands/tablecmds.c:6942"
  - "postgres/src/backend/commands/tablecmds.c:10270"
  - "postgres/src/backend/commands/tablecmds.c:20288"
  - "postgres/src/backend/commands/tablecmds.c:20335"
  - "postgres/src/backend/commands/trigger.c:330"
  - "postgres/src/backend/commands/trigger.c:1349"
  - "postgres/src/backend/commands/trigger.c:1472"
  - "postgres/src/backend/rewrite/rewriteDefine.c:278"
  - "postgres/src/backend/rewrite/rewriteDefine.c:785"
  - "postgres/src/backend/rewrite/rewriteRemove.c:72"
reproduced: false
---

# `permission denied: "%s" is a system catalog`

## What it means

A statement tried to modify a system catalog directly (a table in `pg_catalog`, like `pg_class` or `pg_attribute`) through an operation that is not allowed on catalogs. The placeholder is the catalog name. Catalogs are maintained by DDL, not by direct DML, so `INSERT`/`UPDATE`/`DELETE` and certain DDL against them are blocked.

## When it happens

Running `UPDATE pg_catalog...`, adding a rule, policy, or trigger to a system catalog, or otherwise treating a catalog like an ordinary table. It sometimes appears when a script written for a different system assumes catalogs are writable.

## How to fix

Use the proper DDL to achieve the change instead of editing the catalog. If you truly must modify a catalog (rare, and dangerous), a superuser can set `allow_system_table_mods = on`, but this can corrupt the cluster and should be a last resort under expert guidance. Prefer supported commands (`ALTER`, `GRANT`, etc.).

## Example

*Illustrative* — a direct write to a catalog.

```sql
UPDATE pg_class SET relname = 'x' WHERE relname = 'y';
```

Produces:

```text
ERROR:  permission denied: "pg_class" is a system catalog
```

## Related

- [must be superuser to use raw page functions](./must-be-superuser-to-use-raw-page-functions.md)
- [is not a table](./is-not-a-table.md)
