---
message: "a target detail is required because the configured command includes %%d"
slug: a-target-detail-is-required-because-the-configured-command-includes-d
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/basebackup_to_shell/basebackup_to_shell.c:164"
reproduced: false
---

# `a target detail is required because the configured command includes %%d`

## What it means

The configured command template contains a `%d` placeholder that expects a detail value, but the operation was invoked without one, so the placeholder cannot be filled.

## When it happens

It occurs with configurable command hooks whose command string includes `%d` while the caller provided no detail argument to substitute for it.

## How to fix

Either supply the detail the command expects, or remove the `%d` placeholder from the configured command if the detail is not available in this context. Make the template and the invocation agree, then reload.

## Example

*Illustrative* — a %d placeholder with no detail to fill it.

```text
ERROR:  a target detail is required because the configured command includes %d
```

## Related

- [a target detail is not permitted because the configured command does not include %d](./a-target-detail-is-not-permitted-because-the-configured-command-does-not.md)
- [archive modules have to define the symbol](./archive-modules-have-to-define-the-symbol.md)
