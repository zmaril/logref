---
message: "could not send query: %s"
slug: could-not-send-query
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL, NOTICE]
call_sites:
  - "postgres/contrib/dblink/dblink.c:704"
  - "postgres/contrib/dblink/dblink.c:1108"
  - "postgres/src/bin/pg_rewind/libpq_source.c:476"
reproduced: false
---

# `could not send query: %s`

## What it means

A module that connects to another server (here `dblink`) could not send a query over that connection. The placeholder is the connection error. The outbound libpq connection failed at send time, so the remote query never left the client.

## When it happens

The remote connection was lost or never fully established — the remote server went away, a network failure, or a connection already in a bad state from an earlier error.

## How to fix

Read the appended connection error. Verify the remote server is up and reachable and that the connection is healthy; reconnect (`dblink_connect`) if the handle is stale. Check network reliability and any timeouts between the two servers. Retry once the connection is re-established.

## Example

*Illustrative* — a failed send over a dblink connection.

```text
ERROR:  could not send query: ...
```

## Related

- [wrong number of arguments](./wrong-number-of-arguments.md)
- [subscription could not connect to the publisher](./subscription-could-not-connect-to-the-publisher.md)
