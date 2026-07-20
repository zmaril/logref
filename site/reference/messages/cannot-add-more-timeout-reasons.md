---
message: "cannot add more timeout reasons"
slug: cannot-add-more-timeout-reasons
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/utils/misc/timeout.c:518"
reproduced: false
---

# `cannot add more timeout reasons`

## What it means

Code tried to register another timeout reason after the fixed set of timeout slots was exhausted. The timeout subsystem supports a bounded number of distinct timeout reasons. It is an internal limit check.

## When it happens

It is a can't-happen guard for ordinary workloads. It could appear if many extensions each register their own timeout reasons and collectively exceed the limit.

## How to fix

There is no user action beyond reducing the number of extensions that register timeouts. If it appears, identify extensions that add timeout reasons and report the collision to their authors or the Postgres developers.

## Example

*Illustrative* — the timeout-slot limit.

```text
FATAL:  cannot add more timeout reasons
```

## Related

- [cannot allocate a pmchild slot for backend type](./cannot-allocate-a-pmchild-slot-for-backend-type.md)
- [cannot advance oid counter anymore](./cannot-advance-oid-counter-anymore.md)
