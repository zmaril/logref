---
message: "foreign table \"%s\" does not exist"
slug: foreign-table-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:16688"
  - "postgres/src/backend/commands/tablecmds.c:19387"
reproduced: false
---

# `foreign table "%s" does not exist`

## What it means

A command referenced a foreign table that does not exist. The `%s` is the name. There is no foreign table by that name in the search path or schema given.

## When it happens

Running `ALTER FOREIGN TABLE`, `DROP FOREIGN TABLE`, or a query naming a foreign table that is absent or misspelled, or that is a regular table rather than a foreign one.

## How to fix

Correct the name or schema, create the foreign table, or use `IF EXISTS` where a missing table should be tolerated. Confirm the object is actually a foreign table.

## Example

*Illustrative* — referencing a missing foreign table.

```text
ERROR:  foreign table "remote_t" does not exist
```

## Related

- [foreign-data wrapper has no handler](./foreign-data-wrapper-has-no-handler.md)
- [extension does not exist](./extension-does-not-exist.md)
