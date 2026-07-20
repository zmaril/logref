---
message: "could not connect to target postmaster started with the command:\n%s"
slug: could-not-connect-to-target-postmaster-started-with-the-command
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/server.c:269"
reproduced: false
---

# `could not connect to target postmaster started with the command:
%s`

## What it means

During `pg_upgrade`, the new (target) cluster's postmaster was started but the upgrade tool could not connect to it. The launch command line is echoed so you can inspect it.

## When it happens

It happens when the new cluster starts but does not accept connections — a port conflict, a socket-directory mismatch, or the new server failing during startup.

## How to fix

Check the new server's log for a startup failure, confirm the port and socket directory are free, and verify the new data directory was initialized correctly. Rerun `pg_upgrade` once the new cluster starts cleanly on its own.

## Example

*Illustrative* — `pg_upgrade` unable to reach the new server.

```text
could not connect to target postmaster started with the command:
"/new/bin/pg_ctl" -w -l ... start
```

## Related

- [could not connect to source postmaster started with the command](./could-not-connect-to-source-postmaster-started-with-the-command.md)
- [could not create any TCP/IP sockets](./could-not-create-any-tcp-ip-sockets.md)
