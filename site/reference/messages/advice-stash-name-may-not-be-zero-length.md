---
message: "advice stash name may not be zero length"
slug: advice-stash-name-may-not-be-zero-length
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:347"
reproduced: false
---

# `advice stash name may not be zero length`

## What it means

An advice stash was created with an empty name, and the feature requires a non-empty identifier.

## When it happens

It is raised by the feature managing named advice stashes when the supplied name is the empty string.

## How to fix

Provide a non-empty stash name that satisfies the feature's naming rules. This message comes from a specialized feature rather than a core Postgres object; see its documentation for the exact naming requirements.

## Example

*Illustrative* — an empty stash name.

```text
ERROR:  advice stash name may not be zero length
```

## Related

- [advice stash name must begin with a letter or underscore](./advice-stash-name-must-begin-with-a-letter-or-underscore-and-contain-only.md)
- [advice stash names may not be longer than bytes](./advice-stash-names-may-not-be-longer-than-bytes.md)
