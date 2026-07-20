---
message: "cursor \"%s\" already in use"
slug: cursor-already-in-use
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_CURSOR
    code: "42P03"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2926"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4784"
reproduced: false
---

# `cursor "%s" already in use`

## What it means

A PL/pgSQL `OPEN` targeted a cursor variable that is already open. The `%s` is the cursor name. A bound cursor cannot be opened again while it is still open.

## When it happens

Opening a cursor that was opened earlier and not closed, or reusing a named cursor whose name collides with one already open in the session.

## How to fix

Close the cursor with `CLOSE` before opening it again, or use a distinct cursor variable. For unbound (`refcursor`) cursors, give each a unique name.

## Example

*Illustrative* — opening an already-open cursor.

```text
ERROR:  cursor "my_cursor" already in use
```

## Related

- [cursor variable is null](./cursor-variable-is-null.md)
- [could not open cursor](./could-not-open-cursor.md)
