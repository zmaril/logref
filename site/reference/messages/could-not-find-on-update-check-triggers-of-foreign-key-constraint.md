---
message: "could not find ON UPDATE check triggers of foreign key constraint %u"
slug: could-not-find-on-update-check-triggers-of-foreign-key-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12329"
reproduced: false
---

# `could not find ON UPDATE check triggers of foreign key constraint %u`

## What it means

PostgreSQL could not find the internal check triggers for the update side of a foreign-key constraint. The `%u` is the constraint OID. Foreign keys are implemented with hidden triggers, and one was missing.

## When it happens

It fires during foreign-key maintenance when the constraint's update-check triggers are absent from the catalog. Ordinary usage does not reach it.

## How to fix

This is an internal error, usually a catalog inconsistency. Dropping and recreating the foreign-key constraint rebuilds its internal triggers. Note the constraint and report a reproducible case if it recurs.

## Example

*Illustrative* — missing FK update-check triggers.

```text
ERROR:  could not find ON UPDATE check triggers of foreign key constraint 16400
```

## Related

- [could not find ON INSERT check triggers of foreign key constraint](./could-not-find-on-insert-check-triggers-of-foreign-key-constraint.md)
- [could not find ON UPDATE action trigger of foreign key constraint](./could-not-find-on-update-action-trigger-of-foreign-key-constraint.md)
