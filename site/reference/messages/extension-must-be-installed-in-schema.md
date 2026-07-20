---
message: "extension \"%s\" must be installed in schema \"%s\""
slug: extension-must-be-installed-in-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/extension.c:1943"
reproduced: false
---

# `extension "%s" must be installed in schema "%s"`

## What it means

A `CREATE EXTENSION ... SCHEMA` (or an operation that would relocate it) conflicts with the schema the extension's control file requires. The placeholders are the extension name and the required schema. Some extensions fix the schema they must live in.

## When it happens

It fires when you specify a `SCHEMA` for an extension whose control file sets `schema = ...` (a required schema), or when moving an extension whose schema is pinned.

## How to fix

Install the extension into the schema its control file requires, or omit the `SCHEMA` clause and let it use the required schema. You cannot relocate an extension that pins its schema. If the required schema does not exist, create it first, then run `CREATE EXTENSION` without overriding the schema.

## Example

*Illustrative* — let the extension use its required schema.

```sql
CREATE EXTENSION myext;  -- no SCHEMA override
```

## Related

- [extension is not available](./extension-is-not-available.md)
- [extension already exists](./extension-already-exists.md)
