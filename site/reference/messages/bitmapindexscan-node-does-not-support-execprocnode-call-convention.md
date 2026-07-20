---
message: "BitmapIndexScan node does not support ExecProcNode call convention"
slug: bitmapindexscan-node-does-not-support-execprocnode-call-convention
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapIndexscan.c:42"
reproduced: false
---

# `BitmapIndexScan node does not support ExecProcNode call convention`

## What it means

The executor tried to pull a tuple directly from a bitmap index scan node, which does not return tuples that way. It builds a bitmap for a bitmap heap scan to consume. This is an internal call-convention check.

## When it happens

It is a can't-happen guard in the executor. It would only appear from a bug in execution wiring, not from a query.

## How to fix

There is no user action. If it appears, capture the query and plan along with any extensions that affect scan methods, and report it as a possible bug.

## Example

*Illustrative* — the call-convention guard.

```text
ERROR:  BitmapIndexScan node does not support ExecProcNode call convention
```

## Related

- [bitmapand node does not support execprocnode call convention](./bitmapand-node-does-not-support-execprocnode-call-convention.md)
- [bitmapor node does not support execprocnode call convention](./bitmapor-node-does-not-support-execprocnode-call-convention.md)
