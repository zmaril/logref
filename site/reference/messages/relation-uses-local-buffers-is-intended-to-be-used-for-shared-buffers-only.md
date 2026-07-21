---
message: "relation uses local buffers, %s() is intended to be used for shared buffers only"
slug: relation-uses-local-buffers-is-intended-to-be-used-for-shared-buffers-only
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:755"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:872"
reproduced: false
---

# `relation uses local buffers, %s() is intended to be used for shared buffers only`

## What it means

A buffer-inspection function meant for shared-buffer relations was called on a relation that lives in local buffers (a temporary table). The placeholder is the function name. Temporary relations use process-local buffers the function does not handle.

## When it happens

It arises when passing a temporary table to a function from `pg_buffercache` or a similar shared-buffer inspection utility.

## How to fix

Call the function on an ordinary (non-temporary) relation, which uses shared buffers. Temporary tables are not represented in shared buffers, so shared-buffer inspection does not apply to them.

## Example

*Illustrative* — a shared-buffer function called on a temp table.

```text
ERROR:  relation uses local buffers, pg_buffercache_pages() is intended to be used for shared buffers only
```

## Related

- [relation cannot be null](./relation-cannot-be-null.md)
- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
