---
message: "client %d sending %s"
slug: client-sending
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3163"
  - "postgres/src/bin/pgbench/pgbench.c:3174"
  - "postgres/src/bin/pgbench/pgbench.c:3185"
reproduced: false
---

# `client %d sending %s`

## What it means

A debug trace line from pgbench, reporting that a simulated client is sending a particular command to the server. It is diagnostic output emitted while pgbench runs a script, not a condition to act on.

## When it happens

Running pgbench with debug tracing enabled. Each client logs the commands it dispatches as it steps through its script, and this line marks one such send.

## Is this a problem?

No action is needed. It is expected trace output from pgbench's debug mode. Lower the pgbench debug verbosity if the volume is distracting during a benchmark run.

## Example

*Illustrative* — a pgbench client trace line.

```text
DEBUG:  client 3 sending SELECT 1;
```

## Related

- [discarding connection](./discarding-connection.md)
- [creating directory](./creating-directory.md)
