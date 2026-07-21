---
message: "connection not available"
slug: connection-not-available-f6c759
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_DOES_NOT_EXIST
    code: "08003"
call_sites:
  - "postgres/contrib/dblink/dblink.c:191"
reproduced: false
---

# `connection not available`

## What it means

A `dblink` call that relies on the unnamed (default) persistent connection found none open. An implicit connection must be established before such a call.

## When it happens

It happens with `dblink` functions used without a connection name when no default `dblink_connect` connection is open.

## How to fix

Open a default connection with `dblink_connect('...')` before calling the function, or pass an explicit connection name to a connection you have opened.

## Example

*Illustrative* — a dblink call with no default connection.

```sql
SELECT dblink('SELECT 1');
-- ERROR:  connection not available
```

## Related

- [connection not available](./connection-not-available-a78858.md)
- [connection to server cannot be used due to abort cleanup failure](./connection-to-server-cannot-be-used-due-to-abort-cleanup-failure.md)
