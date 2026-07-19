---
message: "hash AM does not use P_NEW"
slug: hash-am-does-not-use-p-new
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/hash/hashpage.c:75"
  - "postgres/src/backend/access/hash/hashpage.c:101"
  - "postgres/src/backend/access/hash/hashpage.c:140"
  - "postgres/src/backend/access/hash/hashpage.c:204"
  - "postgres/src/backend/access/hash/hashpage.c:246"
reproduced: false
---

# `hash AM does not use P_NEW`

## What it means

Internal error. Hash-index page-allocation code was asked to extend the relation using the generic `P_NEW` sentinel, which the hash access method does not use — it manages its own page allocation through its metapage and bucket layout. It is an assertion-style guard against a misuse of the buffer API.

## When it happens

It should never occur in a correct build. Reaching it means hash-index internals were driven incorrectly, which points to a backend bug or memory corruption, not to user actions.

## How to fix

Treat it as an internal bug. If it recurs on a specific hash index, verify that index with `amcheck` and consider `REINDEX`. Capture the operation and a stack trace and report it.

## Example

*Illustrative* — emitted internally by the hash access method.

```text
ERROR:  hash AM does not use P_NEW
```

## Related

- [fell off the end of index](./fell-off-the-end-of-index.md)
- [invalid overflow block number](./invalid-overflow-block-number.md)
