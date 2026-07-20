---
message: "BitmapOr node does not support ExecProcNode call convention"
slug: bitmapor-node-does-not-support-execprocnode-call-convention
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapOr.c:48"
reproduced: false
---

# `BitmapOr node does not support ExecProcNode call convention`

## What it means

The executor tried to fetch a tuple directly from a bitmap-OR node, which does not produce tuples through the normal interface. It feeds a bitmap heap scan. This is an internal call-convention check.

## When it happens

It is a can't-happen guard in the executor and does not arise from writing a query.

## How to fix

There is no user action. If it appears, capture the query, its plan, and any extensions influencing execution, and report it as a possible bug.

## Example

*Illustrative* — the call-convention guard.

```text
ERROR:  BitmapOr node does not support ExecProcNode call convention
```

## Related

- [bitmapand node does not support execprocnode call convention](./bitmapand-node-does-not-support-execprocnode-call-convention.md)
- [bitmapindexscan node does not support execprocnode call convention](./bitmapindexscan-node-does-not-support-execprocnode-call-convention.md)
