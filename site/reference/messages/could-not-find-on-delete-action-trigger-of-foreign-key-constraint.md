---
message: "could not find ON DELETE action trigger of foreign key constraint %u"
slug: could-not-find-on-delete-action-trigger-of-foreign-key-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12265"
reproduced: false
---

# `could not find ON DELETE action trigger of foreign key constraint %u`

## What it means

PostgreSQL could not find the internal trigger that enforces the `ON DELETE` action of a foreign-key constraint. The `%u` is the constraint OID. Foreign keys are implemented with hidden triggers, and one was missing.

## When it happens

It fires during foreign-key maintenance (such as altering or dropping the constraint) when its `ON DELETE` action trigger is absent from the catalog. Ordinary usage does not reach it.

## How to fix

This is an internal error, usually a catalog inconsistency. Dropping and recreating the foreign-key constraint rebuilds its internal triggers. Note the constraint and report a reproducible case if it recurs.

## Example

*Illustrative* — a missing FK action trigger.

```text
ERROR:  could not find ON DELETE action trigger of foreign key constraint 16400
```

## Related

- [could not find ON UPDATE action trigger of foreign key constraint](./could-not-find-on-update-action-trigger-of-foreign-key-constraint.md)
- [could not find ON INSERT check triggers of foreign key constraint](./could-not-find-on-insert-check-triggers-of-foreign-key-constraint.md)
