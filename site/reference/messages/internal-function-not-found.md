---
message: "internal function \"%s\" not found"
slug: internal-function-not-found
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/parallel.c:1667"
  - "postgres/src/backend/postmaster/bgworker.c:1377"
reproduced: false
---

# `internal function "%s" not found`

## What it means

Internal error. A function declared with language `internal` names a built-in C entry point that the server does not have. The placeholder is the internal function name that could not be resolved.

## When it happens

It fires when creating or calling a function whose `AS 'name'` refers to an internal routine absent from this server build — usually after restoring a dump from a newer version, or a hand-crafted `CREATE FUNCTION ... LANGUAGE internal` naming a nonexistent symbol.

## How to fix

Do not define functions in language `internal` by hand; that language is reserved for built-ins. If this comes from a dump restored onto an older server, the source used a newer built-in — restore onto a matching or newer version, or drop the offending function definition.

## Example

*Illustrative* — an internal function name the build lacks.

```text
ERROR:  internal function "pg_some_new_builtin" not found
```

## Related

- [is not a procedure](./is-not-a-procedure.md)
- [invalid attribute in procedure definition](./invalid-attribute-in-procedure-definition.md)
