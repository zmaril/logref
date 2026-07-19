---
message: "cannot build an initial slot snapshot when snapshots exist"
slug: cannot-build-an-initial-slot-snapshot-when-snapshots-exist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:458"
reproduced: false
---

# `cannot build an initial slot snapshot when snapshots exist`

## What it means

An internal guard in the logical-decoding snapshot builder: it was asked to build an initial slot snapshot while snapshots are already registered in the session. A fresh initial snapshot cannot coexist with active ones, so the build is refused.

## When it happens

It is a can't-happen check reached when a backend requests an initial slot snapshot while it still holds registered snapshots. It reflects incorrect protocol use rather than a data problem.

## How to fix

There is no data-level fix. Ensure the client exports the slot snapshot from a clean transaction state with no active snapshots, and report it if a standard replication tool triggers it.

## Example

*Illustrative* — the existing-snapshots guard.

```text
ERROR:  cannot build an initial slot snapshot when snapshots exist
```

## Related

- [cannot build an initial slot snapshot when myproc xmin already is valid](./cannot-build-an-initial-slot-snapshot-when-myproc-xmin-already-is-valid.md)
- [cannot build an initial slot snapshot before reaching a consistent state](./cannot-build-an-initial-slot-snapshot-before-reaching-a-consistent-state.md)
