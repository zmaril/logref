---
message: "you already exist"
slug: you-already-exist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/proc.c:405"
  - "postgres/src/backend/storage/lmgr/proc.c:636"
reproduced: false
---

# `you already exist`

## What it means

Internal error. A role-lookup consistency check found the current session's own role where it did not expect to — a self-reference guard phrased tersely.

## When it happens

It fires from role or session bookkeeping when the identity being processed is the current role in a context that should have excluded it. Ordinary operations do not produce it.

## How to fix

This is an internal guard. If it appears during normal role activity, capture the operation and the roles involved and report it as a reproducible bug.

## Example

*Illustrative* — a self-reference guard tripping.

```text
ERROR:  you already exist
```

## Related

- [unexpected role type %d](./unexpected-role-type.md)
- [unrecognized AclResult: %d](./unrecognized-aclresult.md)
