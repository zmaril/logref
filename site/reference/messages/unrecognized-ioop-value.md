---
message: "unrecognized IOOp value: %d"
slug: unrecognized-ioop-value
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pgstatfuncs.c:1397"
  - "postgres/src/backend/utils/adt/pgstatfuncs.c:1424"
  - "postgres/src/backend/utils/adt/pgstatfuncs.c:1453"
reproduced: false
---

# `unrecognized IOOp value: %d`

## What it means

Internal error. I/O statistics code was handed an I/O-operation code it does not recognize. The set of tracked I/O operation kinds is fixed, and the value matched none. It is a consistency check in the statistics subsystem.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in I/O statistics reporting, not to anything you can control.

## How to fix

Treat it as an internal bug. Capture the operation that surfaced it (typically reading an I/O statistics view) and report it. There is no user-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized I/O operation code.

```text
ERROR:  unrecognized IOOp value: 7
```

## Related

- [unrecognized item type](./unrecognized-item-type.md)
- [unrecognized cmd type](./unrecognized-cmd-type.md)
