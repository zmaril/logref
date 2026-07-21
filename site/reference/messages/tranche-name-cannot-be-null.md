---
message: "tranche name cannot be NULL"
slug: tranche-name-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/storage/lmgr/lwlock.c:567"
  - "postgres/src/backend/storage/lmgr/lwlock.c:629"
reproduced: false
---

# `tranche name cannot be NULL`

## What it means

A lightweight-lock tranche was registered with a null name. The placeholder-free message reports that a tranche (a named group of LWLocks) must have a non-null name. This concerns extension code that requests named LWLocks.

## When it happens

It arises when an extension calls the LWLock tranche registration API with a null name — a programming error in the extension.

## How to fix

Provide a valid, non-null tranche name when registering LWLocks. This is a fix in the extension's C code that requests the named locks, not a database configuration change.

## Example

*Illustrative* — registering an LWLock tranche with no name.

```text
ERROR:  tranche name cannot be NULL
```

## Related

- [tranche name too long](./tranche-name-too-long.md)
- [relation cannot be null](./relation-cannot-be-null.md)
