---
message: "cannot build an initial slot snapshot when MyProc->xmin already is valid"
slug: cannot-build-an-initial-slot-snapshot-when-myproc-xmin-already-is-valid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:469"
reproduced: false
---

# `cannot build an initial slot snapshot when MyProc->xmin already is valid`

## What it means

An internal guard in the logical-decoding snapshot builder: it was asked to build an initial slot snapshot while the current backend already holds a valid transaction horizon (`xmin`). Holding an `xmin` means a snapshot is already active, so building an initial one would be inconsistent.

## When it happens

It is a can't-happen check reached when snapshot export is requested from a backend that already has an active snapshot. It points to incorrect use of the slot-snapshot protocol rather than a data issue.

## How to fix

There is no data-level fix. If it appears, review the client or extension driving slot creation so it exports the snapshot from a backend without an active transaction snapshot, and report it if standard tools trigger it.

## Example

*Illustrative* — the active-xmin guard.

```text
ERROR:  cannot build an initial slot snapshot when MyProc->xmin already is valid
```

## Related

- [cannot build an initial slot snapshot when snapshots exist](./cannot-build-an-initial-slot-snapshot-when-snapshots-exist.md)
- [cannot build an initial slot snapshot before reaching a consistent state](./cannot-build-an-initial-slot-snapshot-before-reaching-a-consistent-state.md)
