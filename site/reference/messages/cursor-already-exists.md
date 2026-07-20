---
message: "cursor \"%s\" already exists"
slug: cursor-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_CURSOR
    code: "42P03"
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:187"
reproduced: false
---

# `cursor "%s" already exists`

## What it means

A `DECLARE` tried to create a cursor whose name is already in use in the session. The placeholder is the cursor name. Cursor names must be unique among open cursors (portals). The server reports it as a duplicate cursor.

## When it happens

It happens when you `DECLARE` a cursor with a name that is already open — a repeated declaration without closing the first, or two declarations that collide.

## How to fix

Close the existing cursor with `CLOSE name` before declaring another with that name, or choose a different name. If you are reusing a cursor in a loop, make sure each iteration closes it before redeclaring.

## Example

*Illustrative* — declaring a cursor name twice.

```sql
DECLARE c CURSOR FOR SELECT 1;
DECLARE c CURSOR FOR SELECT 2;
-- ERROR:  cursor "c" already exists
```

## Related

- [cursor is not a SELECT query](./cursor-is-not-a-select-query.md)
- [DECLARE CURSOR WITH HOLD is not supported](./declare-cursor-with-hold-is-not-supported.md)
