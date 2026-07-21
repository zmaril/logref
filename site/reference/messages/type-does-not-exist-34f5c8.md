---
message: "type \"%s\" does not exist"
slug: type-does-not-exist-34f5c8
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1722"
  - "postgres/src/backend/commands/functioncmds.c:131"
  - "postgres/src/backend/commands/typecmds.c:278"
  - "postgres/src/backend/commands/typecmds.c:3881"
  - "postgres/src/backend/parser/parse_type.c:241"
  - "postgres/src/backend/parser/parse_type.c:270"
  - "postgres/src/backend/utils/adt/acl.c:4604"
reproduced: false
---

# `type "%s" does not exist`

## What it means

A statement referenced a type that does not exist. The placeholder is the type name. Type resolution failed: no type with that name is visible on the `search_path`, or the name is misspelled or mis-cased.

## When it happens

Declaring a column, cast, or function with an unknown type, referencing a type from an extension that is not installed, or a type in a schema not on the `search_path`. A missing extension (which would have created the type) is a frequent cause.

## How to fix

Check the type name with `\dT` (or `pg_type`). If it belongs to an extension, install the extension (`CREATE EXTENSION ...`) and ensure its schema is on the `search_path`. Correct spelling and case — types created with quoted mixed-case names must be referenced the same way. Qualify the name with its schema if needed.

## Example

*Illustrative* — a column of an unknown type.

```sql
CREATE TABLE t (c citext);
```

Produces:

```text
ERROR:  type "citext" does not exist
```

## Related

- [type %s already exists](./type-already-exists.md)
- [function %s does not exist](./function-does-not-exist-3ae91e.md)
