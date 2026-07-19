---
message: "client %d receiving"
slug: client-receiving
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:4036"
  - "postgres/src/bin/pgbench/pgbench.c:4179"
reproduced: false
---

# `client %d receiving`

## What it means

A `pgbench` debug trace line noting that a simulated client is in its receiving state, waiting for a server response.

## When it happens

It appears when running `pgbench` with debug tracing enabled, as it logs each client's state transitions during a benchmark run.

## Is this a problem?

No action is needed. It is benchmark-tracing output. Run `pgbench` without the debug flag to silence it.

## Example

*Illustrative* — a pgbench client-state trace line.

```text
DEBUG:  client 3 receiving
```

## Related

- [disconnected; waiting %d seconds to try again](./disconnected-waiting-seconds-to-try-again.md)
- [unrecognized initialization step "%c"](./unrecognized-initialization-step.md)
