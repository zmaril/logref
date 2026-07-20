---
message: "language \"%s\" does not exist"
slug: language-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1116"
  - "postgres/src/backend/commands/functioncmds.c:2136"
  - "postgres/src/backend/commands/proclang.c:234"
reproduced: false
---

# `language "%s" does not exist`

## What it means

A function or procedure named a procedural language that is not installed in the current database. The `LANGUAGE` clause must name a language that exists, and this one is not registered.

## When it happens

Creating a function with `LANGUAGE plpython3u`, `LANGUAGE plperl`, or another language that was never installed in this database, or whose extension was dropped. Restoring a dump that uses a language absent from the target is a common trigger.

## How to fix

Install the language before creating the function. Most languages ship as extensions: `CREATE EXTENSION plpython3u` (or the relevant name) registers the language. Confirm the language pack is present on the server, and list installed languages with `\dL` in psql.

## Example

*Illustrative* — a function in an uninstalled language.

```sql
CREATE FUNCTION f() RETURNS int LANGUAGE plperl AS $$ return 1; $$;  -- plperl not installed
```

## Related

- [language is not trusted](./language-is-not-trusted.md)
- [could not access file](./could-not-access-file.md)
