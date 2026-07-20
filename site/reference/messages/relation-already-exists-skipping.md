---
message: "relation \"%s\" already exists, skipping"
slug: relation-already-exists-skipping
passthrough: false
api: [ereport]
level: [NOTICE]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/catalog/index.c:896"
  - "postgres/src/backend/commands/createas.c:421"
  - "postgres/src/backend/commands/sequence.c:150"
  - "postgres/src/backend/parser/parse_utilcmd.c:206"
reproduced: false
---

# `relation "%s" already exists, skipping`

## What it means

A `CREATE ... IF NOT EXISTS` found that the relation already exists and is skipping the creation. The placeholder is the relation name. This is a `NOTICE`, not an error: the `IF NOT EXISTS` clause explicitly asks the server to do nothing (and say so) when the object is already present.

## When it happens

Running `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, or a similar idempotent create for a relation that already exists — common in migration scripts run more than once.

## Is this a problem?

Nothing is wrong; the notice confirms the object was left as-is. Note that `IF NOT EXISTS` only checks the name, not the definition — an existing relation with a different structure is not altered to match, so if you expected a redefinition, use `CREATE OR REPLACE` (where supported) or drop and recreate deliberately.

## Example

*Illustrative* — an idempotent create that skips.

```sql
CREATE TABLE IF NOT EXISTS t (id int);  -- NOTICE: relation "t" already exists, skipping
```

## Related

- [partition with name is already used](./partition-with-name-is-already-used.md)
- [schema does not exist](./schema-does-not-exist.md)
