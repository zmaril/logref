---
message: "could not open extension control file \"%s\": %m"
slug: could-not-open-extension-control-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:745"
reproduced: false
---

# `could not open extension control file "%s": %m`

## What it means

`CREATE EXTENSION` (or a related command) tried to read an extension's control file and could not. The `%m` reason gives the cause. The control file describes the extension's version and requirements.

## When it happens

It happens when the named extension is not installed where the server expects — the control file is missing from `$SHAREDIR/extension`, misnamed, or unreadable — often a typo in the extension name or a package that was never installed.

## How to fix

Confirm the extension is installed for this server version and that `NAME.control` exists in the extension directory and is readable. Installing the extension's package, or correcting the name, resolves it.

## Example

*Illustrative* — a missing extension control file.

```sql
CREATE EXTENSION hstore;
-- ERROR:  could not open extension control file "/usr/share/postgresql/16/extension/hstore.control": No such file or directory
```

## Related

- [could not make operator class be default for type](./could-not-make-operator-class-be-default-for-type.md)
- [could not open dictionary file](./could-not-open-dictionary-file.md)
