---
message: "BitmapAnd node does not support ExecProcNode call convention"
slug: bitmapand-node-does-not-support-execprocnode-call-convention
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapAnd.c:47"
reproduced: false
---

# `BitmapAnd node does not support ExecProcNode call convention`

## What it means

The executor tried to fetch a tuple directly from a bitmap-AND node, but that node does not produce tuples through the normal per-tuple interface. It feeds a bitmap heap scan instead. This is an internal call-convention check.

## When it happens

It is a can't-happen guard in the executor. It would only appear from a bug in plan execution wiring, not from any query.

## How to fix

There is no user action. If it appears, capture the query, its plan, and any extensions that influence execution, and report it as a possible bug.

## Example

*Illustrative* — the call-convention guard.

```text
ERROR:  BitmapAnd node does not support ExecProcNode call convention
```

## Related

- [bitmapor node does not support execprocnode call convention](./bitmapor-node-does-not-support-execprocnode-call-convention.md)
- [bitmapindexscan node does not support execprocnode call convention](./bitmapindexscan-node-does-not-support-execprocnode-call-convention.md)
