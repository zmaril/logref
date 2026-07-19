---
message: "tranche name too long"
slug: tranche-name-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NAME_TOO_LONG
    code: "42622"
call_sites:
  - "postgres/src/backend/storage/lmgr/lwlock.c:572"
  - "postgres/src/backend/storage/lmgr/lwlock.c:634"
reproduced: false
---

# `tranche name too long`

## What it means

A lightweight-lock tranche was registered with a name longer than the allowed maximum. The name of a named LWLock group exceeds the length limit. This concerns extension code requesting named LWLocks.

## When it happens

It arises when an extension registers an LWLock tranche with an over-long name via the tranche registration API.

## How to fix

Shorten the tranche name to within the allowed length. This is a fix in the extension's C code, not a database configuration change.

## Example

*Illustrative* — an over-long LWLock tranche name.

```text
ERROR:  tranche name too long
```

## Related

- [tranche name cannot be NULL](./tranche-name-cannot-be-null.md)
- [too many registered buffers](./too-many-registered-buffers.md)
