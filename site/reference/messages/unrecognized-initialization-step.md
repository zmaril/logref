---
message: "unrecognized initialization step \"%c\""
slug: unrecognized-initialization-step
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:5315"
  - "postgres/src/bin/pgbench/pgbench.c:5380"
reproduced: false
---

# `unrecognized initialization step "%c"`

## What it means

Internal error in `pgbench`. The built-in initialization driver met a step character in its initialization-steps string that is not one of the defined steps.

## When it happens

It fires when `pgbench -I` (or the default init sequence) is handed a steps string containing an unknown character. A valid steps string does not produce it.

## How to fix

This is a guard over the `-I`/`--init-steps` argument. Use only the documented step letters (such as `d`, `t`, `g`, `G`, `v`, `p`, `f`); fix the steps string you passed.

## Example

*Illustrative* — an unknown init step.

```text
ERROR:  unrecognized initialization step "z"
```

## Related

- [client %d receiving](./client-receiving.md)
- [disconnected; waiting %d seconds to try again](./disconnected-waiting-seconds-to-try-again.md)
