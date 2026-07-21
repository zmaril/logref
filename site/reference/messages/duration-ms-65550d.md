---
message: "duration: %s ms"
slug: duration-ms-65550d
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/tcop/fastpath.c:311"
  - "postgres/src/backend/tcop/postgres.c:1389"
  - "postgres/src/backend/tcop/postgres.c:1635"
  - "postgres/src/backend/tcop/postgres.c:2122"
  - "postgres/src/backend/tcop/postgres.c:2411"
reproduced: false
---

# `duration: %s ms`

## What it means

A statement-duration log line. The placeholder is the elapsed time in milliseconds. Postgres emits it (here from the fast-path function-call path) when duration logging is enabled, recording how long an operation took. It is purely informational.

## When it happens

Duration logging is active — `log_duration` is on, or the operation exceeded `log_min_duration_statement` — so the server records the elapsed time for the statement or fast-path call.

## Is this a problem?

This is normal instrumentation, not a problem. Use these lines to find slow operations. If the log volume is too high, raise `log_min_duration_statement` or turn off `log_duration`; if you want more of them, lower the threshold.

## Example

*Illustrative* — a duration log line.

```text
LOG:  duration: 12.480 ms
```

## Related

- [reading](./reading.md)
- [executing in dry-run mode](./executing-in-dry-run-mode.md)
