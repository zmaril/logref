---
message: "maximum number of tranches already registered"
slug: maximum-number-of-tranches-already-registered
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/lwlock.c:584"
  - "postgres/src/backend/storage/lmgr/lwlock.c:641"
reproduced: false
---

# `maximum number of tranches already registered`

## What it means

Internal error. Code tried to register another LWLock tranche after the fixed registration limit was reached. Tranches name groups of lightweight locks; the table that holds them is full. It is a consistency guard in the lock infrastructure.

## When it happens

It fires at startup or extension load when too many LWLock tranches are requested — typically many extensions each registering tranches, or an extension registering in a loop. Ordinary SQL does not surface it.

## How to fix

This is a resource/consistency guard. If it follows loading many extensions, reduce the set of extensions that register tranches, or check an offending extension for repeated registration. Capture `shared_preload_libraries` and report a reproducible case if a single extension causes it.

## Example

*Illustrative* — the tranche table is full.

```text
ERROR:  maximum number of tranches already registered
```

## Related

- [invalid size for shared memory request for](./invalid-size-for-shared-memory-request-for.md)
- [invalid magic number in dynamic shared memory segment](./invalid-magic-number-in-dynamic-shared-memory-segment.md)
