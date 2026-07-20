---
message: "absolute path not allowed"
slug: absolute-path-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/adt/genfile.c:82"
reproduced: false
---

# `absolute path not allowed`

## What it means

A file path was given as an absolute path where only a relative path is permitted, so the server refused it to prevent access outside the allowed area.

## When it happens

It occurs in contexts that restrict file references to a safe subtree — for example certain server-side file functions or configuration references that require a path relative to the data directory.

## How to fix

Supply a relative path instead of an absolute one, resolved against the location the feature expects (often the data directory). If you genuinely need a file elsewhere, use a mechanism intended for that, since the restriction exists to keep access inside a bounded area.

## Example

*Illustrative* — an absolute path where a relative one is required.

```text
ERROR:  absolute path not allowed
```

## Related

- [access to library is not allowed](./access-to-library-is-not-allowed.md)
- [archive location does not exist](./archive-location-does-not-exist.md)
