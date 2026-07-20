---
message: "unexpected operation: %d"
slug: unexpected-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2113"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2813"
reproduced: false
---

# `unexpected operation: %d`

## What it means

Internal error. Code dispatching on a command or row operation received an operation code outside the set it handles.

## When it happens

It fires from executor/replication paths that switch on an operation kind when the value does not match any known case. Ordinary statements do not reach it.

## How to fix

This is an internal guard. Capture the operation in flight and the statement or replication message involved and report it as a reproducible bug.

## Example

*Illustrative* — an unhandled operation code.

```text
ERROR:  unexpected operation: 5
```

## Related

- [unexpected ON CONFLICT specification: %d](./unexpected-on-conflict-specification.md)
- [unexpected operator %u](./unexpected-operator.md)
