---
message: "advice stash name must not contain non-ASCII characters"
slug: advice-stash-name-must-not-contain-non-ascii-characters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:363"
reproduced: false
---

# `advice stash name must not contain non-ASCII characters`

## What it means

An advice stash name included characters outside the ASCII range, which the feature does not allow in stash names.

## When it happens

It is raised by the feature managing named advice stashes when a name contains non-ASCII bytes.

## How to fix

Use only ASCII letters, digits, and underscores in the stash name. This restriction comes from a specialized feature; see its documentation for the full naming rules.

## Example

*Illustrative* — a stash name with a non-ASCII character.

```text
ERROR:  advice stash name must not contain non-ASCII characters
```

## Related

- [advice stash name must begin with a letter or underscore](./advice-stash-name-must-begin-with-a-letter-or-underscore-and-contain-only.md)
- [advice stash names may not be longer than bytes](./advice-stash-names-may-not-be-longer-than-bytes.md)
