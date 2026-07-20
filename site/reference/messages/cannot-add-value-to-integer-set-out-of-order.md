---
message: "cannot add value to integer set out of order"
slug: cannot-add-value-to-integer-set-out-of-order
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/integerset.c:375"
reproduced: false
---

# `cannot add value to integer set out of order`

## What it means

Internal code added a value to an integer-set structure that requires ascending insertion, but the value was smaller than one already present. The structure is built by appending increasing values. It is an internal consistency check.

## When it happens

It is a can't-happen guard in the integer-set structure used by some index-build and maintenance paths, and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, capture the running maintenance operation and any extensions involved, and report it as a possible bug with the server version.

## Example

*Illustrative* — an out-of-order integer-set insert.

```text
ERROR:  cannot add value to integer set out of order
```

## Related

- [cannot add new values to integer set while iteration is in progress](./cannot-add-new-values-to-integer-set-while-iteration-is-in-progress.md)
- [cannot advance oid counter anymore](./cannot-advance-oid-counter-anymore.md)
