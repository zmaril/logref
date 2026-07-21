---
message: "cannot execute %s on relation \"%s\""
slug: cannot-execute-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/repack.c:914"
  - "postgres/src/backend/commands/repack.c:926"
  - "postgres/src/backend/commands/repack.c:935"
  - "postgres/src/backend/commands/repack.c:949"
  - "postgres/src/backend/commands/repack.c:970"
  - "postgres/src/backend/commands/repack.c:979"
reproduced: false
---

# `cannot execute %s on relation "%s"`

## What it means

A command cannot run on the named relation in its current state or configuration. The first placeholder is the command, the second the relation. Used by operations like `repack` that require the relation to satisfy preconditions (an access method, a suitable index, not being in recovery) before they can proceed.

## When it happens

Running an operation on a relation that does not meet its requirements — for example on a standby during recovery, on a relation lacking a needed index or key, or on an object kind the command does not support.

## How to fix

Read the accompanying detail/hint for the specific precondition. Common fixes: run on the primary rather than a standby, ensure the table has the required (unique/primary) key or a supported access method, or target a relation kind the command handles. Satisfy the precondition, then retry.

## Example

*Illustrative* — an operation on a relation that does not qualify.

```text
ERROR:  cannot execute REPACK on relation "logs"
DETAIL:  The relation lacks a suitable index.
```

## Related

- [recovery is in progress](./recovery-is-in-progress.md)
- [only heap AM is supported](./only-heap-am-is-supported.md)
