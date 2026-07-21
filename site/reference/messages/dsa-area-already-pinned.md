---
message: "dsa_area already pinned"
slug: dsa-area-already-pinned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:996"
reproduced: false
---

# `dsa_area already pinned`

## What it means

An internal guard in the dynamic-shared-area code. `dsa_pin` was called on an area that was already pinned. Pinning keeps an area alive beyond its creator; pinning twice is a programming error. This is a "can't happen" check.

## When it happens

It fires when DSA-using code (an extension or a core feature) pins an area that is already pinned, indicating a logic error in that code rather than a user action.

## How to fix

This is not a user query error. If it comes from an extension, that extension double-pins a DSA and needs a fix. For core features, capture the log and server version and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  dsa_area already pinned
```

## Related

- [dsa_area not pinned](./dsa-area-not-pinned.md)
- [dsa_area could not attach to a segment that has been freed](./dsa-area-could-not-attach-to-a-segment-that-has-been-freed.md)
