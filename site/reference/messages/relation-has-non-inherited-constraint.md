---
message: "relation %u has non-inherited constraint \"%s\""
slug: relation-has-non-inherited-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14838"
  - "postgres/src/backend/commands/tablecmds.c:18823"
reproduced: false
---

# `relation %u has non-inherited constraint "%s"`

## What it means

A consistency report about inheritance. A relation identified by OID has a constraint that is marked as not inherited where the operation expected an inherited one (or vice versa). The placeholders are the relation OID and constraint name.

## When it happens

It surfaces during inheritance/partition maintenance and consistency checks when a child's constraint local/inherited flag does not match what the parent relationship implies — for example after an irregular `ALTER TABLE ... ADD CONSTRAINT ... NO INHERIT` history.

## How to fix

Reconcile the constraint's inheritance status. Depending on intent, add or drop the constraint on the parent so children inherit it, or adjust the child so its local/inherited marking is consistent. Investigate how the mismatch arose to avoid recurrence.

## Example

*Illustrative* — a child holding a non-inherited constraint unexpectedly.

```text
ERROR:  relation 16452 has non-inherited constraint "chk_amount"
```

## Related

- [relation "%s" would be inherited from more than once](./relation-would-be-inherited-from-more-than-once.md)
- [%d pg_constraint record(s) missing for relation "%s"](./pg-constraint-record-s-missing-for-relation.md)
