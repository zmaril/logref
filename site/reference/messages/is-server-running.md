---
message: "Is server running?\n"
slug: is-server-running
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1037"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1096"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1158"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1197"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1278"
reproduced: false
---

# `Is server running?
`

## What it means

A diagnostic line a client tool appends after a failed connection attempt, prompting you to check whether the server is actually up. It is part of a connection-failure message from tools like `pg_ctl`/`pg_isready`, not an error on its own.

## When it happens

A tool could not reach the server — the postmaster is stopped, is listening on a different host/port/socket than the client is trying, or is still starting up. The preceding line carries the underlying connection error.

## Is this a problem?

Confirm the server is running (`pg_ctl status`, or check the process and `postmaster.pid`). Verify the client is pointed at the right host, port, and socket directory, and that `listen_addresses` and firewall rules permit the connection. Read the error line above this one for the specific failure.

## Example

*Illustrative* — appended to a failed connection.

```text
could not connect to server: Connection refused
	Is the server running on host "localhost" and accepting connections?
```

## Related

- [PID file does not exist](./pid-file-does-not-exist.md)
- [could not establish connection](./could-not-establish-connection.md)
