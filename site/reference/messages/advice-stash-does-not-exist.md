---
message: "advice stash \"%s\" does not exist"
slug: advice-stash-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:461"
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:505"
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:679"
  - "postgres/contrib/pg_stash_advice/stashfuncs.c:178"
reproduced: false
---

# `advice stash "%s" does not exist`

## What it means

An operation referenced a named advice stash that is not registered. The placeholder is the stash name. This comes from the `pg_stash_advice` extension, whose stashes are named objects; referring to one that was not created is rejected.

## When it happens

Using a `pg_stash_advice` function with a stash name that was never created, was removed, or is misspelled.

## How to fix

Confirm the stash exists (per the extension's catalog/functions) and correct the name, or create the stash first. Consult the `pg_stash_advice` documentation for how stashes are created and listed.

## Example

*Illustrative* — referencing a missing advice stash.

```text
ERROR:  advice stash "nightly" does not exist
```

## Related

- [subscription does not exist](./subscription-does-not-exist.md)
- [server does not exist](./server-does-not-exist.md)
