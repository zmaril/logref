---
message: "dsa_area not pinned"
slug: dsa-area-not-pinned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:1016"
reproduced: false
---

# `dsa_area not pinned`

## What it means

An internal guard in the dynamic-shared-area code. `dsa_unpin` was called on an area that was not pinned. Unpinning something never pinned is a programming error. This is a "can't happen" check.

## When it happens

It fires when DSA-using code unpins an area whose pin count is already zero, indicating a logic error in that code.

## How to fix

This is not a user query error. If it comes from an extension, that extension has unbalanced pin/unpin calls. For core features, capture the log and server version and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  dsa_area not pinned
```

## Related

- [dsa_area already pinned](./dsa-area-already-pinned.md)
- [dsa_area space must be at least, but provided](./dsa-area-space-must-be-at-least-but-provided.md)
