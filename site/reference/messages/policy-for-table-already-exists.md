---
message: "policy \"%s\" for table \"%s\" already exists"
slug: policy-for-table-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/policy.c:696"
  - "postgres/src/backend/commands/policy.c:1148"
reproduced: true
---

# `policy "%s" for table "%s" already exists`

## What it means

A `CREATE POLICY` named a row-security policy that already exists on the target table. The placeholders are the policy name and the table. Policy names must be unique per table.

## When it happens

It arises when creating a policy whose name is already taken on that table — a re-run of a migration, or a naming collision with an existing policy.

## How to fix

Use a different policy name, or alter the existing policy with `ALTER POLICY` instead of creating a new one. If the old policy is obsolete, `DROP POLICY name ON table` first. Guard migrations so they do not create the same policy twice.

## Example

*Reproduced* — captured from `reproducers/scenarios/49_rls_policies_defaclr.sql`.

```sql
CREATE POLICY p_dup ON acl49.t USING (true);
```

Produces:

```text
ERROR:  policy "p_dup" for table "t" already exists
```

## Related

- [rule "%s" for relation "%s" already exists](./rule-for-relation-already-exists.md)
- [trigger "%s" for relation "%s" already exists](./trigger-for-relation-already-exists.md)
