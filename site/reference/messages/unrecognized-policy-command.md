---
message: "unrecognized policy command"
slug: unrecognized-policy-command
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/policy.c:125"
  - "postgres/src/backend/commands/policy.c:138"
reproduced: false
---

# `unrecognized policy command`

## What it means

Internal error. Row-security code met a policy-command code (the `ALL`/`SELECT`/`INSERT`/`UPDATE`/`DELETE` selector on a policy) outside the defined set.

## When it happens

It fires where a policy's command is switched on and the value is not a known case — a sign of an inconsistent `pg_policy` row, not of ordinary DDL.

## How to fix

This is an internal guard. If routine policy use or DDL triggers it, capture the policy definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized policy command.

```text
ERROR:  unrecognized policy command
```

## Related

- [unrecognized AclResult: %d](./unrecognized-aclresult.md)
- [user "%s" cannot replicate into relation with row-level security enabled: "%s"](./user-cannot-replicate-into-relation-with-row-level-security-enabled.md)
