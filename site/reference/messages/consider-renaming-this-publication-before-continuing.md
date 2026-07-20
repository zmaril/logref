---
message: "Consider renaming this publication before continuing."
slug: consider-renaming-this-publication-before-continuing
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1829"
reproduced: false
---

# `Consider renaming this publication before continuing.`

## What it means

`pg_createsubscriber` reported a hint that a publication name it wants to use is already taken, and suggests renaming that publication before proceeding. It is guidance attached to a failure, not a standalone error.

## When it happens

It happens during `pg_createsubscriber` setup when a publication with a conflicting name already exists on the target.

## How to fix

Rename or drop the conflicting publication, or adjust the tool's naming so it does not collide, then rerun the setup. Check existing publications with `\dRp`.

## Example

*Illustrative* — the hint accompanying a publication-name clash.

```text
pg_createsubscriber: hint: Consider renaming this publication before continuing.
```

## Related

- [connection to database failed](./connection-to-database-failed-ed5fa7.md)
- [could not alter replication slot](./could-not-alter-replication-slot.md)
