---
message: "function name \"%s\" is not unique"
slug: function-name-is-not-unique
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_FUNCTION
    code: "42725"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2311"
  - "postgres/src/backend/parser/parse_func.c:2588"
reproduced: true
---

# `function name "%s" is not unique`

## What it means

A function name resolved to more than one candidate where a single one was required. The `%s` is the name. Overloading made the reference ambiguous in a context that does not accept argument types to disambiguate.

## When it happens

Referencing a function by name alone (for example in some `ALTER`/`DROP` or object-address contexts) when several overloaded functions share that name.

## How to fix

Qualify the function with its argument types, for example `my_func(integer, text)`, so exactly one candidate matches. Use the full signature in the command.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
DROP FUNCTION repro.ambi;
```

Produces:

```text
ERROR:  function name "repro.ambi" is not unique
```

## Related

- [function with OID does not exist](./function-with-oid-does-not-exist.md)
- [functions cannot have more than argument](./functions-cannot-have-more-than-argument.md)
