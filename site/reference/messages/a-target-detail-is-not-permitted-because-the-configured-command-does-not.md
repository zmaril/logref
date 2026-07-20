---
message: "a target detail is not permitted because the configured command does not include %%d"
slug: a-target-detail-is-not-permitted-because-the-configured-command-does-not
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/basebackup_to_shell/basebackup_to_shell.c:169"
reproduced: false
---

# `a target detail is not permitted because the configured command does not include %%d`

## What it means

A detail argument was supplied for an operation, but the configured command template does not contain the placeholder that would consume it, so the detail has nowhere to go.

## When it happens

It occurs with configurable command hooks (for example an archive or SSL-passphrase command) when a detail value is provided yet the command string lacks the corresponding `%d`-style placeholder.

## How to fix

Either add the expected placeholder to the configured command so it can receive the detail, or stop passing the detail. Align the command template with the arguments the caller supplies, then reload the configuration.

## Example

*Illustrative* — a detail supplied to a command with no matching placeholder.

```text
ERROR:  a target detail is not permitted because the configured command does not include %d
```

## Related

- [a target detail is required because the configured command includes %d](./a-target-detail-is-required-because-the-configured-command-includes-d.md)
- [archive modules must register an archive callback](./archive-modules-must-register-an-archive-callback.md)
