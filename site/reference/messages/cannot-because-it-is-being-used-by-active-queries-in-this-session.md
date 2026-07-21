---
message: "cannot %s \"%s\" because it is being used by active queries in this session"
slug: cannot-because-it-is-being-used-by-active-queries-in-this-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4514"
reproduced: false
---

# `cannot %s "%s" because it is being used by active queries in this session`

## What it means

An `ALTER TABLE` or similar operation on a table was blocked because a query in the same session still has the table open — for example an open cursor or a running query scanning it. The operation cannot change the table while it is in active use. The first placeholder is the attempted action.

## When it happens

It occurs when you try to alter or drop a table that a cursor or in-progress query in the current session is still reading.

## How to fix

Close the open cursors and let any in-progress scans finish before altering or dropping the table. The change can proceed once nothing in the session is actively using the relation.

## Example

*Illustrative* — altering a table used by a cursor.

```text
ERROR:  cannot ALTER TABLE "t" because it is being used by active queries in this session
```

## Related

- [cannot because it has pending trigger events](./cannot-because-it-has-pending-trigger-events.md)
- [cannot change relation](./cannot-change-relation.md)
