---
message: "did not find subXID %u in MyProc"
slug: did-not-find-subxid-in-myproc
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:4053"
  - "postgres/src/backend/storage/ipc/procarray.c:4069"
reproduced: false
---

# `did not find subXID %u in MyProc`

## What it means

Internal warning. Subtransaction bookkeeping expected to find a given subtransaction id in the current process's cached list and did not.

## When it happens

It fires as a consistency check in subtransaction handling when the in-memory subXID cache and the operation disagree. Ordinary transactions do not produce it.

## Is this a problem?

This is an internal consistency warning. It is usually harmless in isolation; if it recurs, capture the workload (especially heavy subtransaction use or savepoints) and report it.

## Example

*Illustrative* — a missing cached subXID.

```text
WARNING:  did not find subXID 12345 in MyProc
```

## Related

- [no pg_subtrans entry for subcommitted XID %u](./no-pg-subtrans-entry-for-subcommitted-xid.md)
- [leaked parallel context](./leaked-parallel-context.md)
