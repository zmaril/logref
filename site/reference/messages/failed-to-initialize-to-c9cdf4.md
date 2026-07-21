---
message: "failed to initialize %s to %d"
slug: failed-to-initialize-to-c9cdf4
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:1548"
  - "postgres/src/backend/utils/misc/guc.c:1564"
  - "postgres/src/backend/utils/misc/guc.c:1614"
reproduced: false
---

# `failed to initialize %s to %d`

## What it means

Internal error. During startup, GUC (configuration) machinery failed to initialize a parameter to a required value. The placeholders name the parameter and the value it tried to set. Reaching this at initialization means a built-in default could not be applied, which is a `can't happen` condition.

## When it happens

It does not arise from ordinary configuration changes. It points to an internal inconsistency in the parameter system at startup — a bug or a badly built server — rather than to a user's `postgresql.conf` value (which produces clearer, separate errors).

## How to fix

Treat it as an internal bug. Confirm the server binary is a correct, matching build for the platform. Capture the named parameter and value and the startup context and report it. It is distinct from ordinary invalid-setting errors, which name the offending value directly.

## Example

*Illustrative* — emitted internally during GUC initialization.

```text
FATAL:  failed to initialize work_mem to 4096
```

## Related

- [parameter requires a Boolean value](./parameter-requires-a-boolean-value.md)
- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
