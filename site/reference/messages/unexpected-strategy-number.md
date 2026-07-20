---
message: "unexpected strategy number %d"
slug: unexpected-strategy-number
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtreadpage.c:1803"
  - "postgres/src/backend/optimizer/path/indxpath.c:3640"
reproduced: false
---

# `unexpected strategy number %d`

## What it means

Internal error. Index or operator-class code received a strategy number (the small integer identifying an operator's role in an operator class) that is not valid for the access method in use.

## When it happens

It fires from index scan or planning code when a strategy number falls outside the range the access method defines. A correctly declared operator class does not produce it.

## How to fix

This is an internal guard. A custom or corrupt operator class can provoke it; verify the operator-class definition, and report a reproducible case with the class and query if it recurs.

## Example

*Illustrative* — an out-of-range strategy number.

```text
ERROR:  unexpected strategy number 9
```

## Related

- [unrecognized strategy: %d](./unrecognized-strategy.md)
- [unexpected operator %u](./unexpected-operator.md)
