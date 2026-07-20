---
message: "check constraints for domains cannot be marked NO INHERIT"
slug: check-constraints-for-domains-cannot-be-marked-no-inherit
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:985"
reproduced: false
---

# `check constraints for domains cannot be marked NO INHERIT`

## What it means

A domain `CHECK` constraint was defined with `NO INHERIT`. Inheritance does not apply to domain constraints, so the `NO INHERIT` marker has no meaning and is rejected.

## When it happens

It occurs on `CREATE DOMAIN ... CHECK (...) NO INHERIT` or `ALTER DOMAIN ... ADD CHECK (...) NO INHERIT`.

## How to fix

Remove `NO INHERIT` from the domain check constraint. Domain constraints apply to the domain's values directly, without an inheritance concept.

## Example

*Illustrative* — NO INHERIT on a domain check.

```sql
CREATE DOMAIN d AS int CHECK (VALUE > 0) NO INHERIT;
-- ERROR:  check constraints for domains cannot be marked NO INHERIT
```

## Related

- [check constraint name appears multiple times but with different expressions](./check-constraint-name-appears-multiple-times-but-with-different-expressions.md)
- [cannot use table references in domain check constraint](./cannot-use-table-references-in-domain-check-constraint.md)
