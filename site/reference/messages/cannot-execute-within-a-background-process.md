---
message: "cannot execute %s within a background process"
slug: cannot-execute-within-a-background-process
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/tcop/utility.c:826"
reproduced: false
---

# `cannot execute %s within a background process`

## What it means

A command that is not supported inside a background worker was issued from one. Some utility commands need a full user backend and cannot run in a background process. The placeholder is the command name.

## When it happens

It occurs when a background worker — such as one started by an extension or a maintenance task — issues a command that Postgres restricts to interactive backends.

## How to fix

Run the command from a regular client session instead of a background worker. If an extension needs the operation, redesign it to perform the command in a foreground backend.

## Example

*Illustrative* — a command run from a background worker.

```text
ERROR:  cannot execute VACUUM within a background process
```

## Related

- [cannot execute within security-restricted operation](./cannot-execute-within-security-restricted-operation.md)
- [cannot execute during a parallel operation](./cannot-execute-during-a-parallel-operation.md)
