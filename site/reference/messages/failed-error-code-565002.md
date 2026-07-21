---
message: "%s() failed: error code %d"
slug: failed-error-code-565002
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:253"
reproduced: false
---

# `%s() failed: error code %d`

## What it means

A `pg_dump` parallel worker reported that a system call failed, giving the function name and an operating-system error code. The placeholders are the function and the code. It surfaces a low-level failure inside parallel dump coordination (notably on Windows).

## When it happens

It fires during a parallel `pg_dump` or `pg_restore` (`-j`) when a threading or synchronization system call returns an error — for example a thread, event, or handle operation failing under resource pressure.

## How to fix

Look up the reported function and error code for the specific cause. Reduce the parallelism (`-j`) if the host is short on resources such as handles, memory, or threads. Ensure the machine is healthy and not overloaded, then retry. Persistent failures with the same function are worth reporting with the exact code.

## Example

*Illustrative* — the message as logged.

```
pg_dump: error: CreateThread() failed: error code 8
```

## Related

- [expected format differs from format found in file](./expected-format-differs-from-format-found-in-file.md)
- [failed sanity check, relation with OID not found](./failed-sanity-check-relation-with-oid-not-found.md)
