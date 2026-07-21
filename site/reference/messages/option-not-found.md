---
message: "option \"%s\" not found"
slug: option-not-found
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:157"
  - "postgres/src/backend/commands/foreigncmds.c:166"
reproduced: true
---

# `option "%s" not found`

## What it means

A command referenced an option by name and no option with that name exists on the object it was applied to. The placeholder is the option name that could not be resolved.

## When it happens

It arises when altering the options of an object — a foreign server, foreign table, user mapping, or similar — with `SET`/`DROP` on an option that was never defined, or whose name is misspelled.

## How to fix

List the object's current options first (for example `\des+` for foreign servers or the relevant catalog view) and use the exact option name. To add a new option use `ADD` rather than `SET`, and to remove one use `DROP` only if it is actually present.

## Example

*Reproduced* — captured from `reproducers/scenarios/43_contrib_fdw_indexam.sql`.

```sql
ALTER SERVER pgfdw OPTIONS (SET fetch_size 'notanumber');
```

Produces:

```text
ERROR:  option "fetch_size" not found
```

## Related

- [storage "%s" not recognized](./storage-not-recognized.md)
- [permission denied to set the "%s" option of a file_fdw foreign table](./permission-denied-to-set-the-option-of-a-file-fdw-foreign-table.md)
