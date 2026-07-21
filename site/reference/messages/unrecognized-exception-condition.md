---
message: "unrecognized exception condition \"%s\""
slug: unrecognized-exception-condition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:2161"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:2210"
reproduced: true
---

# `unrecognized exception condition "%s"`

## What it means

A PL/pgSQL `EXCEPTION WHEN` clause (or a `GET STACKED DIAGNOSTICS` condition) named a condition that is not one of the defined error-condition names.

## When it happens

It arises when compiling or running a PL/pgSQL block whose handler names a condition PostgreSQL does not know — a typo, or a condition name that does not exist.

## How to fix

Use a valid condition name from the documented error-condition list (for example `unique_violation`, `division_by_zero`), or catch a whole class such as `data_exception`. Fix the spelling of the condition in the `WHEN` clause.

## Example

*Reproduced* — captured from `reproducers/scenarios/26_roles_acl_plpgsql.sql`.

```sql
DO $$ BEGIN RAISE EXCEPTION USING errcode = 'nonsense_code'; END $$;
```

Produces:

```text
ERROR:  unrecognized exception condition "nonsense_code"
```

## Related

- [unrecognized plpgsql itemtype: %d](./unrecognized-plpgsql-itemtype.md)
- [unexpected RAISE parameter list length](./unexpected-raise-parameter-list-length.md)
