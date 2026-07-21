---
message: "can't attach the same segment more than once"
slug: can-t-attach-the-same-segment-more-than-once
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:700"
reproduced: false
---

# `can't attach the same segment more than once`

## What it means

Code tried to attach a dynamic shared-memory segment that the current process already has attached. A process may hold only one attachment per segment. It is an internal consistency check.

## When it happens

It is a can't-happen guard in dynamic shared-memory handling and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, note any extension that uses dynamic shared memory and report it as a possible bug with the server version.

## Example

*Illustrative* — a double attach.

```text
ERROR:  can't attach the same segment more than once
```

## Related

- [cannot allocate a pmchild slot for backend type](./cannot-allocate-a-pmchild-slot-for-backend-type.md)
- [cannot add new values to integer set while iteration is in progress](./cannot-add-new-values-to-integer-set-while-iteration-is-in-progress.md)
