---
message: "user \"%s\" cannot replicate into relation with row-level security enabled: \"%s\""
slug: user-cannot-replicate-into-relation-with-row-level-security-enabled
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:1472"
  - "postgres/src/backend/replication/logical/worker.c:2638"
reproduced: false
---

# `user "%s" cannot replicate into relation with row-level security enabled: "%s"`

## What it means

A logical-replication apply worker tried to write into a target table that has row-level security enabled, running as a role that is subject to that security — which replication apply does not support.

## When it happens

It arises on a subscriber when the subscription's owning role is not exempt from RLS on the target table. Apply must be able to write rows unconditionally, and an RLS-restricted role cannot.

## How to fix

Own the subscription with a role that bypasses RLS on the target — a superuser, a role with `BYPASSRLS`, or the table owner where the owner is exempt. Alternatively adjust the table's policies so the apply role is not restricted.

## Example

*Illustrative* — replicating into an RLS-protected table.

```text
ERROR:  user "sub_role" cannot replicate into relation with row-level security enabled: "private"
```

## Related

- [unrecognized policy command](./unrecognized-policy-command.md)
- [user-defined indexes on system catalog tables are not supported](./user-defined-indexes-on-system-catalog-tables-are-not-supported.md)
