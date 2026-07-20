---
message: "cannot drop extension \"%s\" because it is being modified"
slug: cannot-drop-extension-because-it-is-being-modified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/extension.c:2354"
reproduced: false
---

# `cannot drop extension "%s" because it is being modified`

## What it means

A `DROP EXTENSION` ran while the same extension was in the middle of being created, altered, or updated. The extension is locked for modification, so it cannot be dropped at the same time. The placeholder is the extension name.

## When it happens

It occurs when a drop overlaps a `CREATE EXTENSION`, `ALTER EXTENSION`, or extension update — often from concurrent sessions or a script issuing both.

## How to fix

Let the in-progress extension operation finish, then drop the extension. Serialize extension changes so a drop does not race with a create or update.

## Example

*Illustrative* — dropping an extension mid-change.

```text
ERROR:  cannot drop extension "ext" because it is being modified
```

## Related

- [cannot drop because other objects depend on it](./cannot-drop-because-other-objects-depend-on-it.md)
- [cannot drop replication slot](./cannot-drop-replication-slot.md)
