---
message: "portal \"%s\" does not exist"
slug: portal-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_CURSOR
    code: "34000"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:2191"
  - "postgres/src/backend/tcop/postgres.c:2843"
reproduced: false
---

# `portal "%s" does not exist`

## What it means

A command referenced a portal (an open cursor or the internal object backing one) by a name that is not currently open. The placeholder is the portal name. Portals exist only within the session and transaction that created them.

## When it happens

It arises from the extended query protocol or explicit cursor operations — `FETCH`/`MOVE`/`CLOSE` on a cursor that was never opened, already closed, or closed by transaction end (unless it is a holdable cursor).

## How to fix

Open the cursor with `DECLARE` before fetching, and keep the fetch within the same transaction unless the cursor was declared `WITH HOLD`. In client libraries, check that the prepared statement/portal lifecycle matches the driver's expectations.

## Example

*Illustrative* — fetching from a portal that is not open.

```text
ERROR:  portal "my_cursor" does not exist
```

## Related

- [prepared statement is not a SELECT](./prepared-statement-is-not-a-select.md)
- [savepoint "%s" does not exist within current savepoint level](./savepoint-does-not-exist-within-current-savepoint-level.md)
