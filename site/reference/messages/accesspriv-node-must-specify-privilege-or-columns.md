---
message: "AccessPriv node must specify privilege or columns"
slug: accesspriv-node-must-specify-privilege-or-columns
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:573"
reproduced: false
---

# `AccessPriv node must specify privilege or columns`

## What it means

Internal handling of a privilege node required either a named privilege or a column list and found neither, so it cannot process the grant or revoke it represents.

## When it happens

It is raised in the same privilege-processing path as the related check, when an `AccessPriv` node lacks both a privilege name and column targets — normally only reachable through a construction bug.

## How to fix

This is an internal invariant rather than a user-level error. If you encounter it, record the statement and any extension that builds privilege nodes and report it; ordinary `GRANT`/`REVOKE` syntax does not produce it.

## Example

*Illustrative* — a privilege node missing both privilege and columns.

```text
ERROR:  AccessPriv node must specify privilege or columns
```

## Related

- [AccessPriv node must specify privilege](./accesspriv-node-must-specify-privilege.md)
- [accessexclusivelock required to add toast table](./accessexclusivelock-required-to-add-toast-table.md)
