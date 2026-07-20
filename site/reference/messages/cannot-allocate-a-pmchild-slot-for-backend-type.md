---
message: "cannot allocate a PMChild slot for backend type %d"
slug: cannot-allocate-a-pmchild-slot-for-backend-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/pmchild.c:184"
reproduced: false
---

# `cannot allocate a PMChild slot for backend type %d`

## What it means

The postmaster could not assign a child-process slot for a backend of the given type. The placeholder is the backend-type code. The pool of child slots is sized at startup, and none was available. It is an internal capacity guard.

## When it happens

It is a can't-happen condition under normal sizing, reached only if the accounting of child-process slots is inconsistent with the configured limits.

## How to fix

There is no direct user action. If it appears, capture the server log around the event and the connection and worker settings in effect, and report it with the server version. It is not caused by ordinary SQL.

## Example

*Illustrative* — the child-slot guard.

```text
ERROR:  cannot allocate a PMChild slot for backend type 3
```

## Related

- [cannot add more timeout reasons](./cannot-add-more-timeout-reasons.md)
- [cannot advance oid counter anymore](./cannot-advance-oid-counter-anymore.md)
