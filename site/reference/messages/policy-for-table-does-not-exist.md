---
message: "policy \"%s\" for table \"%s\" does not exist"
slug: policy-for-table-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/policy.c:897"
  - "postgres/src/backend/commands/policy.c:1176"
  - "postgres/src/backend/commands/policy.c:1247"
reproduced: true
---

# `policy "%s" for table "%s" does not exist`

## What it means

A command referenced a row-level security policy by name on a table that has no policy by that name. The policy name must belong to the table the command targets, and it does not.

## When it happens

Running `ALTER POLICY` or `DROP POLICY` with a misspelled policy name, a name that was already dropped, or a name that belongs to a different table.

## How to fix

List the table's policies with `\d tablename` in psql or query `pg_policies`, and use the exact policy name. Confirm the policy was not removed by an earlier migration, and that you are naming the correct table.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
DROP POLICY nosuchpol ON repro.parent;
```

Produces:

```text
ERROR:  policy "nosuchpol" for table "parent" does not exist
```

## Related

- [rule for relation does not exist](./rule-for-relation-does-not-exist.md)
- [index for table does not exist](./index-for-table-does-not-exist.md)
