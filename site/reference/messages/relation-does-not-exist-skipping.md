---
message: "relation \"%s\" does not exist, skipping"
slug: relation-does-not-exist-skipping
passthrough: false
api: [ereport]
level: [NOTICE]
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1311"
  - "postgres/src/backend/commands/sequence.c:456"
  - "postgres/src/backend/commands/tablecmds.c:4115"
  - "postgres/src/backend/commands/tablecmds.c:4276"
  - "postgres/src/backend/commands/tablecmds.c:4328"
  - "postgres/src/backend/commands/tablecmds.c:19666"
  - "postgres/src/backend/tcop/utility.c:1330"
reproduced: false
---

# `relation "%s" does not exist, skipping`

## What it means

A `DROP ... IF EXISTS` (or a partition/sequence detach that tolerates absence) found the named relation missing and is skipping it rather than raising an error. The placeholder is the relation name. This is a `NOTICE`, not a failure — the `IF EXISTS` clause turns the missing-object error into this informational message.

## When it happens

`DROP TABLE IF EXISTS x`, `DROP SEQUENCE IF EXISTS x`, or similar when `x` does not exist. Common in idempotent migration scripts that drop objects that may or may not be present.

## Is this a problem?

Nothing to fix — this is the intended behavior of `IF EXISTS`. The statement succeeds and the notice just tells you the object was not there to drop. If you did not expect the object to be missing, investigate why (wrong database/schema, a prior drop), but the command itself did what you asked.

## Example

*Illustrative* — dropping a table that is not present.

```sql
DROP TABLE IF EXISTS not_there;
```

Produces:

```text
NOTICE:  relation "not_there" does not exist, skipping
```

## Related

- [relation "%s" does not exist](./relation-does-not-exist-d06d8d.md)
- [relation "%s" already exists](./relation-already-exists.md)
