---
message: "cannot collect transition tuples from child foreign tables"
slug: cannot-collect-transition-tuples-from-child-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/trigger.c:2580"
  - "postgres/src/backend/commands/trigger.c:2841"
  - "postgres/src/backend/commands/trigger.c:3188"
reproduced: false
---

# `cannot collect transition tuples from child foreign tables`

## What it means

A statement-level trigger with transition tables (an `AFTER` trigger declared `REFERENCING OLD/NEW TABLE`) fired on a partitioned or inheritance tree that includes foreign-table children, and the transition tuples cannot be gathered from those foreign children. Foreign tables do not expose the local tuple stream transition tables rely on.

## When it happens

Running DML on a partitioned/inherited table that has foreign-table partitions or children while a transition-table trigger is defined on the parent.

## How to fix

Avoid combining transition-table triggers with foreign-table children: either drop the transition-table trigger, or restructure so the foreign tables are not part of a hierarchy whose parent carries such a trigger. Row-level triggers, or logic that does not depend on transition tables, sidestep the limitation.

## Example

*Illustrative* — a transition-table trigger over foreign children.

```text
ERROR:  cannot collect transition tuples from child foreign tables
```

## Related

- [cannot lock rows in foreign table](./cannot-lock-rows-in-foreign-table.md)
- [access to non-system foreign table is restricted](./access-to-non-system-foreign-table-is-restricted.md)
