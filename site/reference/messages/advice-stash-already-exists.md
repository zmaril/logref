---
message: "advice stash \"%s\" already exists"
slug: advice-stash-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:436"
reproduced: false
---

# `advice stash "%s" already exists`

## What it means

A named advice stash was created with a name that is already in use by an existing stash, and the feature that emits this requires stash names to be unique.

## When it happens

It is raised by the specific extension/feature that manages named advice stashes when a create request collides with an existing name.

## How to fix

Choose a different stash name, or drop or reuse the existing one. This message comes from a feature that maintains named stashes; consult that feature's documentation for how to list and manage them. It is not a core Postgres object type.

## Example

*Illustrative* — creating a stash whose name is taken.

```text
ERROR:  advice stash "planner" already exists
```

## Related

- [advice stash name may not be zero length](./advice-stash-name-may-not-be-zero-length.md)
- [advice stash name must begin with a letter or underscore](./advice-stash-name-must-begin-with-a-letter-or-underscore-and-contain-only.md)
