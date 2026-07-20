---
message: "cannot add a node to an inner tuple without node labels"
slug: cannot-add-a-node-to-an-inner-tuple-without-node-labels
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:2290"
reproduced: false
---

# `cannot add a node to an inner tuple without node labels`

## What it means

An SP-GiST index operation tried to add a labeled node to an inner tuple that has no node labels. Nodes must be either all labeled or all unlabeled within a tuple, so mixing them is invalid. It is an internal guard in the SP-GiST access method.

## When it happens

It is a can't-happen check in SP-GiST index maintenance, reached only through a custom or buggy SP-GiST operator class rather than ordinary indexing.

## How to fix

There is no user action for built-in operator classes. If a custom SP-GiST operator class is in use, its node-label handling is inconsistent; report it to that operator class's author.

## Example

*Illustrative* — the node-label guard.

```text
ERROR:  cannot add a node to an inner tuple without node labels
```

## Related

- [cannot add a node to an allthesame inner tuple](./cannot-add-a-node-to-an-allthesame-inner-tuple.md)
- [cannot add value to integer set out of order](./cannot-add-value-to-integer-set-out-of-order.md)
