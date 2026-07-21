---
message: "currval of sequence \"%s\" is not yet defined in this session"
slug: currval-of-sequence-is-not-yet-defined-in-this-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/sequence.c:885"
reproduced: true
---

# `currval of sequence "%s" is not yet defined in this session`

## What it means

`currval()` was called for a sequence that this session has not yet drawn a value from. `currval` returns the value most recently obtained by `nextval` in the current session, and there is none yet. The placeholder is the sequence name.

## When it happens

It happens when you call `currval('seq')` (or `lastval()` with no prior `nextval`) before any `nextval('seq')` has run in the same session.

## How to fix

Call `nextval()` on the sequence first in this session, then `currval()` returns that value. `currval` is session-local by design, so a value fetched in another session does not count. Reorder your statements so a `nextval` precedes the `currval`.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
SELECT currval('repro.churn_id_seq');
```

Produces:

```text
ERROR:  currval of sequence "churn_id_seq" is not yet defined in this session
```

## Related

- [cursor is not a SELECT query](./cursor-is-not-a-select-query.md)
- [current transaction is aborted](./current-transaction-is-aborted.md)
