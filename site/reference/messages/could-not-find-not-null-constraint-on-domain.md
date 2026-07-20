---
message: "could not find not-null constraint on domain \"%s\""
slug: could-not-find-not-null-constraint-on-domain
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/typecmds.c:2828"
reproduced: false
---

# `could not find not-null constraint on domain "%s"`

## What it means

A command operating on a domain's NOT NULL constraint could not find the constraint it expected in the catalog. The `%s` names the domain. This is an internal consistency check.

## When it happens

It fires during domain DDL (such as dropping or altering a NOT NULL constraint) when the constraint entry cannot be located. Ordinary domain operations do not reach it.

## How to fix

This is an internal error, often tied to a catalog inconsistency or concurrent DDL on the domain. Note the domain and the command and report a reproducible case if the catalog is intact.

## Example

*Illustrative* — a missing domain NOT NULL constraint.

```text
ERROR:  could not find not-null constraint on domain "my_domain"
```

## Related

- [could not find on delete action trigger of foreign key constraint](./could-not-find-on-delete-action-trigger-of-foreign-key-constraint.md)
- [could not find pg_class entry for](./could-not-find-pg-class-entry-for.md)
