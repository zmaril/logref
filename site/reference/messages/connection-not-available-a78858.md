---
message: "connection \"%s\" not available"
slug: connection-not-available-a78858
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_DOES_NOT_EXIST
    code: "08003"
call_sites:
  - "postgres/contrib/dblink/dblink.c:187"
reproduced: true
---

# `connection "%s" not available`

## What it means

A `dblink` operation referenced a named connection that is not currently open. The named persistent connection must exist before it can be used.

## When it happens

It happens with `dblink` functions that take a connection name when that name was never opened with `dblink_connect`, or was already closed.

## How to fix

Open the named connection first with `dblink_connect('name', '...')`, and make sure it is not closed before use. Check that the connection name matches exactly.

## Example

*Reproduced* — captured from `reproducers/scenarios/43_contrib_fdw_indexam.sql`.

```sql
SELECT dblink_disconnect('nonexistent_conn');
```

Produces:

```text
ERROR:  connection "nonexistent_conn" not available
```

## Related

- [connection not available](./connection-not-available-f6c759.md)
- [connection to server cannot be used due to abort cleanup failure](./connection-to-server-cannot-be-used-due-to-abort-cleanup-failure.md)
