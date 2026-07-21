---
message: "cannot update in frozen hashtable \"%s\""
slug: cannot-update-in-frozen-hashtable
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1099"
reproduced: false
---

# `cannot update in frozen hashtable "%s"`

## What it means

An internal guard fired: code tried to modify an in-memory hash table that had been frozen. Freezing a dynahash table marks it read-only to make it shareable, so any further insert or update is rejected.

## When it happens

It is reached from hash-table code that a server subsystem or extension marked frozen. It reflects a coding issue in the owner of that table rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the code that froze and then wrote to the table.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot update in frozen hashtable "my_table"
```

## Related

- [cannot update during bootstrap](./cannot-update-during-bootstrap.md)
- [cannot update SecondarySnapshot during a parallel operation](./cannot-update-secondarysnapshot-during-a-parallel-operation.md)
