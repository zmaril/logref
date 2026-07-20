---
message: "advice stash name must begin with a letter or underscore and contain only letters, digits, and underscores"
slug: advice-stash-name-must-begin-with-a-letter-or-underscore-and-contain-only
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:373"
reproduced: false
---

# `advice stash name must begin with a letter or underscore and contain only letters, digits, and underscores`

## What it means

An advice stash name broke the identifier rules: it must start with a letter or underscore and contain only letters, digits, and underscores.

## When it happens

It is raised by the feature managing named advice stashes when a name starts with a digit or includes disallowed characters.

## How to fix

Rename the stash to a valid identifier — begin with a letter or underscore and use only letters, digits, and underscores. This is a naming rule from a specialized feature; consult its documentation for details.

## Example

*Illustrative* — a stash name starting with a digit.

```text
ERROR:  advice stash name must begin with a letter or underscore and contain only letters, digits, and underscores
```

## Related

- [advice stash name must not contain non-ASCII characters](./advice-stash-name-must-not-contain-non-ascii-characters.md)
- [advice stash name may not be zero length](./advice-stash-name-may-not-be-zero-length.md)
