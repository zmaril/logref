---
message: "could not connect to source postmaster started with the command:\n%s"
slug: could-not-connect-to-source-postmaster-started-with-the-command
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/server.c:265"
reproduced: false
---

# `could not connect to source postmaster started with the command:
%s`

## What it means

During `pg_upgrade`, the old (source) cluster's postmaster was started but the upgrade tool could not connect to it. The command line it used to launch the old server is echoed so you can inspect it.

## When it happens

It happens early in `pg_upgrade` when the old cluster starts but does not accept connections — a bad port, a socket-directory mismatch, or the old server failing during its own startup.

## How to fix

Check the old server's log for a startup failure, confirm the port and socket directory `pg_upgrade` chose are free, and make sure the old binaries and data directory match. Rerun `pg_upgrade` once the old cluster starts cleanly on its own.

## Example

*Illustrative* — `pg_upgrade` unable to reach the old server.

```text
could not connect to source postmaster started with the command:
"/old/bin/pg_ctl" -w -l ... start
```

## Related

- [could not connect to target postmaster started with the command](./could-not-connect-to-target-postmaster-started-with-the-command.md)
- [could not delete directory](./could-not-delete-directory.md)
