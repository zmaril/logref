---
message: "archive modules must register an archive callback"
slug: archive-modules-must-register-an-archive-callback
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/pgarch.c:944"
reproduced: false
---

# `archive modules must register an archive callback`

## What it means

A configured archive module initialized but did not register the callback that actually archives a file, so the server has no function to call to archive WAL.

## When it happens

It occurs when an archive module's init routine runs but fails to set the required archive callback — usually a module bug or an incompatible module version.

## How to fix

Use an archive module that registers its archive callback correctly, matched to the server version. If you maintain the module, register the callback in its init function. Check the module version against the running server.

## Example

*Illustrative* — an archive module that registers no callback.

```text
ERROR:  archive modules must register an archive callback
```

## Related

- [archive modules have to define the symbol](./archive-modules-have-to-define-the-symbol.md)
- [a target detail is required because the configured command includes %d](./a-target-detail-is-required-because-the-configured-command-includes-d.md)
