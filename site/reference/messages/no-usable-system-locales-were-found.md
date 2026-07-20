---
message: "no usable system locales were found"
slug: no-usable-system-locales-were-found
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:968"
  - "postgres/src/backend/commands/collationcmds.c:1053"
reproduced: false
---

# `no usable system locales were found`

## What it means

A warning that a locale-related step could not find any usable system locales to work with.

## When it happens

It arises from `initdb`/`pg_import_system_collations` and similar paths when the operating system reports no locales the tool can use — a minimal or misconfigured locale environment.

## Is this a problem?

Install and generate system locales on the host (for example via the operating system's locale package and `locale-gen`), then re-run the step. Confirm `locale -a` lists usable locales for the server's user.

## Example

*Illustrative* — no usable locales found.

```text
WARNING:  no usable system locales were found
```

## Related

- [unrecognized locale provider: %s](./unrecognized-locale-provider-f222bb.md)
- [disabling huge pages](./disabling-huge-pages.md)
