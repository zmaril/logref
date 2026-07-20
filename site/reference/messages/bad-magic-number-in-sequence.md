---
message: "bad magic number in sequence \"%s\": %08X"
slug: bad-magic-number-in-sequence
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/sequence.c:1205"
reproduced: false
---

# `bad magic number in sequence "%s": %08X`

## What it means

Reading a sequence relation, the server found a page whose magic number does not match what a sequence page must contain. The placeholders are the sequence name and the value read. The magic number validates that the page is a real sequence page.

## When it happens

It is raised when a sequence's storage is damaged, or when something other than a sequence occupies the relation's file. It reflects corruption rather than a query error.

## How to fix

Treat this as data corruption in the named sequence. Check storage and hardware, restore the sequence from backup, or recreate it and reset its value with `setval`. Investigate whether other objects on the same storage are affected.

## Example

*Illustrative* — a sequence page failing its magic check.

```text
ERROR:  bad magic number in sequence "order_id_seq": 00000000
```

## Related

- [block is a meta page](./block-is-a-meta-page.md)
- [bogus pg_index tuple](./bogus-pg-index-tuple.md)
