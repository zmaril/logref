---
message: "cursor \"%s\" does not exist"
slug: cursor-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_NAME
    code: "34000"
  - symbol: ERRCODE_UNDEFINED_CURSOR
    code: "34000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:665"
  - "postgres/src/backend/commands/portalcmds.c:198"
  - "postgres/src/backend/commands/portalcmds.c:251"
  - "postgres/src/backend/executor/execCurrent.c:68"
  - "postgres/src/backend/utils/adt/xml.c:2978"
  - "postgres/src/backend/utils/adt/xml.c:3148"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4950"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5038"
reproduced: true
---

# `cursor "%s" does not exist`

## What it means

A `FETCH`, `MOVE`, `CLOSE`, or `WHERE CURRENT OF` referred to a cursor name that is not open in the current session. The placeholder is the name used. Cursors are session- and often transaction-scoped, so a name that was valid a moment ago can be gone.

## When it happens

Referencing a cursor that was never declared, was already closed, or was automatically closed at transaction end. A non-`WITH HOLD` cursor is destroyed when its transaction commits, so fetching from it afterward raises this. Typos in the cursor name do too.

## How to fix

`DECLARE` the cursor before using it, and keep the `FETCH`/`CLOSE` inside the same transaction unless the cursor was declared `WITH HOLD` (which lets it survive commit). If you need a result set to outlive the transaction, add `WITH HOLD` at declaration. Verify the name matches the `DECLARE` exactly.

## Example

*Reproduced* — The transaction/session reproducer scenario closes an undeclared cursor (`14_txn_session.sql`).

```sql
CLOSE nonexistent_cursor;
```

Produces:

```text
ERROR:  cursor "nonexistent_cursor" does not exist
```

## Related

- [wrong number of parameters for prepared statement](./wrong-number-of-parameters-for-prepared-statement.md)
- [there is no transaction in progress](./there-is-no-transaction-in-progress.md)
