---
message: "text search configuration \"%s\" does not exist"
slug: text-search-configuration-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR, NOTICE]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3267"
  - "postgres/src/backend/commands/tsearchcmds.c:1166"
  - "postgres/src/backend/utils/cache/ts_cache.c:636"
reproduced: false
---

# `text search configuration "%s" does not exist`

## What it means

A command or query referenced a text-search configuration that is not registered. Text-search configurations govern how documents and queries are parsed and normalized, and no configuration by the given name exists in the resolved schema.

## When it happens

Naming a configuration in `to_tsvector('cfg', ...)`, `SET default_text_search_config`, or a text-search command, where the name is misspelled, lives in a schema not on the search path, or was never created.

## How to fix

Use an existing configuration name, schema-qualifying it if needed. List available configurations with `\dF` in psql, and confirm any custom configuration was created and is reachable via the search path. Built-in language configurations like `english` live in `pg_catalog`.

## Example

*Illustrative* — an unknown text-search configuration.

```sql
SELECT to_tsvector('englsh', 'hello');  -- no such configuration
```

## Related

- [text search dictionary does not exist](./text-search-dictionary-does-not-exist-849de0.md)
- [text search parser does not support headline creation](./text-search-parser-does-not-support-headline-creation.md)
