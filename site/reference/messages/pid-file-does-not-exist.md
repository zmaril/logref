---
message: "%s: PID file \"%s\" does not exist\n"
slug: pid-file-does-not-exist
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1036"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1094"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1157"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1196"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1277"
reproduced: false
---

# `%s: PID file "%s" does not exist
`

## What it means

A tool (here `pg_ctl`) looked for the server's PID file (`postmaster.pid`) in the data directory and did not find it. The placeholders are the program name and the file path. Without the PID file, `pg_ctl` cannot determine or signal the running server.

## When it happens

Running `pg_ctl stop`/`restart`/`status` against a data directory whose server is not running (a stopped server removes its PID file), or pointing `pg_ctl` at the wrong `-D` data directory.

## Is this a problem?

Check that the server is actually running and that `-D` points at the correct data directory. If the server is stopped, that is expected — start it with `pg_ctl start`. A missing PID file for a server you believe is running suggests a wrong data directory or that it crashed; inspect the logs.

## Example

*Illustrative* — pg_ctl against a stopped server.

```text
pg_ctl: PID file "/data/postmaster.pid" does not exist
```

## Related

- [Is server running?](./is-server-running.md)
- [could not establish connection](./could-not-establish-connection.md)
