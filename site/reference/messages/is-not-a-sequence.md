---
message: "\"%s\" is not a sequence"
slug: is-not-a-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/sequence/sequence.c:73"
  - "postgres/src/backend/catalog/aclchk.c:1840"
  - "postgres/src/backend/catalog/objectaddress.c:1467"
  - "postgres/src/backend/commands/tablecmds.c:20374"
  - "postgres/src/backend/utils/adt/acl.c:2151"
  - "postgres/src/backend/utils/adt/acl.c:2181"
  - "postgres/src/backend/utils/adt/acl.c:2214"
  - "postgres/src/backend/utils/adt/acl.c:2250"
  - "postgres/src/backend/utils/adt/acl.c:2281"
  - "postgres/src/backend/utils/adt/acl.c:2312"
reproduced: false
---

# `"%s" is not a sequence`

## What it means

A sequence operation was applied to an object that is not a sequence. The placeholder is the object name. Functions like `nextval`, `currval`, `setval`, and `ALTER SEQUENCE` require an actual sequence relation, and the named object is a table, view, or something else.

## When it happens

Calling `nextval('t')` where `t` is a table, `setval` on the wrong name, or `ALTER SEQUENCE` on a non-sequence. A common cause is passing a table name where the associated sequence name was intended.

## How to fix

Point the operation at a real sequence. If you meant the sequence backing a serial/identity column, find its name with `pg_get_serial_sequence('table','column')`. Check `\d name` to confirm the object's type. Correct the name to the sequence itself.

## Example

*Illustrative* — nextval on a table.

```sql
SELECT nextval('users');
```

Produces:

```text
ERROR:  "users" is not a sequence
```

## Related

- [is not a table](./is-not-a-table.md)
- [cache lookup failed for sequence](./cache-lookup-failed-for-sequence.md)
