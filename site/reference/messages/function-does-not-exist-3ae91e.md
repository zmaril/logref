---
message: "function %s does not exist"
slug: function-does-not-exist-3ae91e
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:859"
  - "postgres/src/backend/commands/functioncmds.c:702"
  - "postgres/src/backend/commands/typecmds.c:2053"
  - "postgres/src/backend/commands/typecmds.c:2099"
  - "postgres/src/backend/commands/typecmds.c:2151"
  - "postgres/src/backend/commands/typecmds.c:2188"
  - "postgres/src/backend/commands/typecmds.c:2222"
  - "postgres/src/backend/commands/typecmds.c:2256"
  - "postgres/src/backend/commands/typecmds.c:2290"
  - "postgres/src/backend/commands/typecmds.c:2319"
  - "postgres/src/backend/commands/typecmds.c:2406"
  - "postgres/src/backend/commands/typecmds.c:2448"
  - "postgres/src/backend/parser/parse_func.c:427"
  - "postgres/src/backend/parser/parse_func.c:458"
  - "postgres/src/backend/parser/parse_func.c:485"
  - "postgres/src/backend/parser/parse_func.c:499"
  - "postgres/src/backend/parser/parse_func.c:629"
  - "postgres/src/backend/parser/parse_func.c:649"
  - "postgres/src/backend/parser/parse_func.c:2302"
  - "postgres/src/backend/parser/parse_func.c:2575"
reproduced: true
---

# `function %s does not exist`

## What it means

A function or procedure was referenced that does not exist with the given name and argument types. The placeholder is the function signature Postgres tried to resolve. Overload resolution failed: no candidate matched the name and the supplied argument types (after allowed implicit casts).

## When it happens

Calling a function with the wrong number or types of arguments, a misspelled or mis-cased name, a function that lives in a schema not on the `search_path`, or one that was never created (a missing extension is a common cause).

## How to fix

Check the name and argument types against `\df name`. If the types differ, add explicit casts so a candidate matches, or call the intended overload. If the function belongs to an extension, ensure the extension is installed and its schema is on the `search_path`. Quote the name if it was created with case-sensitive identifiers.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
CREATE FOREIGN DATA WRAPPER fdw HANDLER nosuchfn;
```

Produces:

```text
ERROR:  function nosuchfn() does not exist
```

## Related

- [function %s must return type %s](./function-must-return-type.md)
- [type %s does not exist](./type-does-not-exist-34f5c8.md)
