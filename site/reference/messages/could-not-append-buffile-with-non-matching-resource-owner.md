---
message: "could not append BufFile with non-matching resource owner"
slug: could-not-append-buffile-with-non-matching-resource-owner
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:912"
reproduced: false
---

# `could not append BufFile with non-matching resource owner`

## What it means

Internal temporary-file (BufFile) code tried to append a file whose resource owner does not match the expected one. Resource owners must line up for safe cleanup, so the mismatch is rejected. This is an internal check.

## When it happens

It fires in shared temporary-file handling (used by parallel sorts, hash joins, and similar) when the resource-owner bookkeeping is inconsistent.

## How to fix

This is an internal error rather than a user setting. Capture the query and plan that triggered it and report it; it typically indicates a bug in temporary-file management rather than anything you configured.

## Example

*Illustrative* — a BufFile append with a mismatched owner.

```text
ERROR:  could not append BufFile with non-matching resource owner
```

## Related

- [could not attach to a SharedFileSet that is already destroyed](./could-not-attach-to-a-sharedfileset-that-is-already-destroyed.md)
- [could not attach to per-session DSM segment](./could-not-attach-to-per-session-dsm-segment.md)
