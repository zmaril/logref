---
message: "cannot create policy on conflict log table \"%s\""
slug: cannot-create-policy-on-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/policy.c:88"
reproduced: false
---

# `cannot create policy on conflict log table "%s"`

## What it means

A `CREATE POLICY` targeted a table designated as a logical-replication conflict log table. Conflict log tables have a fixed managed role and do not accept row-security policies. The placeholder is the table name.

## When it happens

It occurs when defining a row-security policy on the relation currently serving as the conflict logging target.

## How to fix

Do not attach policies to a conflict log table. Manage conflict logging through the subscription configuration rather than adding row security to the log table.

## Example

*Illustrative* — a policy on a conflict log table.

```text
ERROR:  cannot create policy on conflict log table "t"
```

## Related

- [cannot create statistics on conflict log table](./cannot-create-statistics-on-conflict-log-table.md)
- [cannot create trigger on conflict log table](./cannot-create-trigger-on-conflict-log-table.md)
