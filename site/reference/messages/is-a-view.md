---
message: "\"%s\" is a view"
slug: is-a-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:275"
  - "postgres/src/backend/commands/trigger.c:282"
  - "postgres/src/backend/commands/trigger.c:458"
reproduced: true
---

# `"%s" is a view`

## What it means

A command that acts on tables was pointed at a view. A view is a stored query, not a base relation, so operations that assume physical storage or table-only semantics do not apply to it.

## When it happens

Attaching a constraint or trigger of a kind views do not support, or running a storage-oriented command against a name that resolves to a view rather than a table.

## How to fix

If you meant a table, correct the name or schema. If the operation makes sense on a view, use the view-appropriate form — for example an `INSTEAD OF` trigger rather than a row-level `BEFORE`/`AFTER` trigger. To change what the view returns, use `CREATE OR REPLACE VIEW`.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
CREATE TRIGGER trg AFTER INSERT ON repro.child_v FOR EACH ROW EXECUTE FUNCTION repro.addone();
```

Produces:

```text
ERROR:  "child_v" is a view
```

## Related

- [is not a view](./is-not-a-view-960471.md)
- [is a foreign table](./is-a-foreign-table.md)
