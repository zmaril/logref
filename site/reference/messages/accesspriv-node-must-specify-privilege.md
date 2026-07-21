---
message: "AccessPriv node must specify privilege"
slug: accesspriv-node-must-specify-privilege
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1063"
reproduced: false
---

# `AccessPriv node must specify privilege`

## What it means

Internal parse-tree handling for a privilege node found it carried neither a privilege name nor any columns, so it could not determine what privilege the node represents.

## When it happens

It is raised when processing a `GRANT`/`REVOKE` parse node (`AccessPriv`) that is malformed — normally only reachable through a bug in query construction or an extension building nodes directly.

## How to fix

This is an internal invariant, not a user-facing SQL error you would hit from normal statements. If it appears, capture the exact command and any extensions that construct privilege statements, and report it. There is no query-level workaround.

## Example

*Illustrative* — a privilege node with nothing specified.

```text
ERROR:  AccessPriv node must specify privilege
```

## Related

- [AccessPriv node must specify privilege or columns](./accesspriv-node-must-specify-privilege-or-columns.md)
- [accessexclusivelock required to add toast table](./accessexclusivelock-required-to-add-toast-table.md)
