---
message: "cannot add a node to an allTheSame inner tuple"
slug: cannot-add-a-node-to-an-allthesame-inner-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:2207"
reproduced: false
---

# `cannot add a node to an allTheSame inner tuple`

## What it means

An SP-GiST index operation tried to add a node to an inner tuple marked as allTheSame, which is not permitted. An allTheSame inner tuple routes every value the same way and has a fixed node structure. It is an internal guard in the SP-GiST access method.

## When it happens

It is a can't-happen check in SP-GiST index maintenance, typically reached only through a custom or buggy SP-GiST operator class rather than ordinary indexing.

## How to fix

There is no user action for built-in operator classes. If a custom SP-GiST operator class is in use, its picksplit or choose logic is producing an invalid structure; report it to that operator class's author.

## Example

*Illustrative* — the allTheSame guard.

```text
ERROR:  cannot add a node to an allTheSame inner tuple
```

## Related

- [cannot add a node to an inner tuple without node labels](./cannot-add-a-node-to-an-inner-tuple-without-node-labels.md)
- [cannot accept a value of a shell type](./cannot-accept-a-value-of-a-shell-type.md)
