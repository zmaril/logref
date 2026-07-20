---
message: "could not find a function named \"%s\""
slug: could-not-find-a-function-named
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2297"
  - "postgres/src/backend/parser/parse_func.c:2570"
reproduced: false
---

# `could not find a function named "%s"`

## What it means

A command referenced a function by name that does not exist. The placeholder is the function name. No function of that name (in the resolved search path) could be found for the operation to act on.

## When it happens

Referring to a function in a context that resolves by name — for example in `ALTER`/`COMMENT`/`DROP` object references, or extension scripts — where the name is misspelled, unqualified against the wrong search path, or the function was not created.

## How to fix

Check the function name and schema, and confirm the function exists (`\df name` in psql). Schema-qualify it if the search path is the issue, and ensure any extension or migration that defines it ran first. Correct the name to one that exists.

## Example

*Illustrative* — referencing a missing function.

```text
ERROR:  could not find a function named "do_thing"
```

## Related

- [cannot change routine kind](./cannot-change-routine-kind.md)
- [cache lookup failed for procedure](./cache-lookup-failed-for-procedure.md)
