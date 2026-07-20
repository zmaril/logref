---
message: "extension \"%s\" does not exist"
slug: extension-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/extension.c:237"
  - "postgres/src/backend/commands/extension.c:3515"
reproduced: false
---

# `extension "%s" does not exist`

## What it means

A command referenced an extension that is not installed in the current database. The `%s` is the extension name. There is no matching row in `pg_extension`.

## When it happens

Running `ALTER EXTENSION`, `DROP EXTENSION`, `COMMENT ON EXTENSION`, or a dependency that names an extension not installed here, or misspelling the name.

## How to fix

Install it with `CREATE EXTENSION name` (in the right database), or correct the name. Use `DROP EXTENSION IF EXISTS` when a missing extension should be tolerated.

## Example

*Illustrative* — referencing a missing extension.

```text
ERROR:  extension "hstore" does not exist
```

## Related

- [extension does not support SET SCHEMA](./extension-does-not-support-set-schema.md)
- [foreign-data wrapper has no handler](./foreign-data-wrapper-has-no-handler.md)
