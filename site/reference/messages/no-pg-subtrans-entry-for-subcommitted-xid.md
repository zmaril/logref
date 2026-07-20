---
message: "no pg_subtrans entry for subcommitted XID %u"
slug: no-pg-subtrans-entry-for-subcommitted-xid
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/transam.c:161"
  - "postgres/src/backend/access/transam/transam.c:216"
reproduced: false
---

# `no pg_subtrans entry for subcommitted XID %u`

## What it means

Internal warning, or a sign of corruption. Subtransaction lookup expected a `pg_subtrans` entry for a subcommitted transaction id and found none.

## When it happens

It fires from subtransaction-status handling when the `pg_subtrans` structure lacks an entry it should have — usually an internal inconsistency or damaged `pg_subtrans` data.

## Is this a problem?

This is a consistency guard over subtransaction state. If it recurs, investigate storage health and any prior crash; capture the workload (heavy savepoint/subtransaction use) and report it.

## Example

*Illustrative* — a missing pg_subtrans entry.

```text
WARNING:  no pg_subtrans entry for subcommitted XID 12345
```

## Related

- [did not find subXID %u in MyProc](./did-not-find-subxid-in-myproc.md)
- [wrong tuple length](./wrong-tuple-length.md)
