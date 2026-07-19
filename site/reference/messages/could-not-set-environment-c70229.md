---
message: "could not set environment"
slug: could-not-set-environment-c70229
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2672"
reproduced: false
---

# `could not set environment`

## What it means

`initdb` could not set an environment variable it needs for the rest of the run. Setting the environment lets the tool run its bootstrap steps with the right locale and encoding context.

## When it happens

It fires during `initdb` when a call to change the process environment fails, which is an unusual operating-system-level failure.

## How to fix

This points at an OS problem in the environment `initdb` is running in rather than a configuration mistake. Check for memory pressure or an unusual restricted environment, and rerun in a normal shell. Capture the output if it recurs on a standard host.

## Example

*Illustrative* — setting the environment failed.

```text
initdb: error: could not set environment
```

## Related

- [could not read password from file](./could-not-read-password-from-file.md)
- [could not set session user to](./could-not-set-session-user-to.md)
