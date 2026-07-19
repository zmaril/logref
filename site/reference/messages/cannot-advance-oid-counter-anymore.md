---
message: "cannot advance OID counter anymore"
slug: cannot-advance-oid-counter-anymore
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:626"
reproduced: false
---

# `cannot advance OID counter anymore`

## What it means

The cluster's OID counter could not be advanced because it has cycled through the available OID space under conditions where a new value cannot be obtained. OIDs identify system objects, and this guard fires when the allocator cannot make progress.

## When it happens

It is a rare internal condition tied to OID exhaustion or the OID-allocation logic, not to ordinary object creation, which handles wraparound normally.

## How to fix

There is no direct user action. Investigate what is consuming OIDs at an extreme rate, capture the operation that raised it, and report it with the server version. This is not expected under normal use.

## Example

*Illustrative* — the OID-counter guard.

```text
ERROR:  cannot advance OID counter anymore
```

## Related

- [cannot add more timeout reasons](./cannot-add-more-timeout-reasons.md)
- [cannot allocate a pmchild slot for backend type](./cannot-allocate-a-pmchild-slot-for-backend-type.md)
