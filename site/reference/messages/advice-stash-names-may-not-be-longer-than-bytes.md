---
message: "advice stash names may not be longer than %d bytes"
slug: advice-stash-names-may-not-be-longer-than-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:353"
reproduced: false
---

# `advice stash names may not be longer than %d bytes`

## What it means

An advice stash name exceeded the maximum byte length the feature permits for stash names.

## When it happens

It is raised by the feature managing named advice stashes when a supplied name is longer than the allowed limit.

## How to fix

Shorten the stash name to within the byte limit stated in the message. This length rule comes from a specialized feature; consult its documentation for the exact maximum.

## Example

*Illustrative* — an over-long stash name.

```text
ERROR:  advice stash names may not be longer than 63 bytes
```

## Related

- [advice stash name may not be zero length](./advice-stash-name-may-not-be-zero-length.md)
- [advice stash name must begin with a letter or underscore](./advice-stash-name-must-begin-with-a-letter-or-underscore-and-contain-only.md)
