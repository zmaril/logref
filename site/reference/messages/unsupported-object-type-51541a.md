---
message: "unsupported object type: %d"
slug: unsupported-object-type-51541a
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2810"
  - "postgres/src/backend/catalog/aclchk.c:2951"
  - "postgres/src/backend/catalog/objectaddress.c:2664"
  - "postgres/src/backend/commands/dropcmds.c:497"
  - "postgres/src/backend/commands/dropcmds.c:513"
  - "postgres/src/backend/commands/event_trigger.c:2335"
  - "postgres/src/backend/commands/event_trigger.c:2420"
reproduced: false
---

# `unsupported object type: %d`

## What it means

Internal error. Generic object-handling code (ACLs, `DROP`, `COMMENT`, dependency processing) was asked to operate on an object type it does not support in that path. The placeholder is the numeric object type. The kind of object is known to the catalog but not handled by this particular operation.

## When it happens

A bug in core or an extension, or applying an operation to an object kind it was not built to handle. It can also appear when a newer object type meets an older code path. Ordinary usage does not trigger it.

## How to fix

Treat it as a bug. Note the operation (a `DROP`, `COMMENT`, `ALTER`, or ACL change) and the object involved, and report it. If an extension registers object types, suspect it and confirm version alignment. A reproducible sequence is the most useful thing to capture.

## Example

*Illustrative* — emitted internally during generic object handling.

```text
ERROR:  unsupported object type: 42
```

## Related

- [unrecognized object type: %d](./unrecognized-object-type-4cec17.md)
- [unrecognized node type](./unrecognized-node-type.md)
