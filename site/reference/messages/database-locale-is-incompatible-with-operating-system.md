---
message: "database locale is incompatible with operating system"
slug: database-locale-is-incompatible-with-operating-system
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:442"
reproduced: false
---

# `database locale is incompatible with operating system`

## What it means

At startup the server found that a database's stored locale does not match what the operating system currently provides. A mismatch can change sort order and character classification, which would corrupt indexes built under the old locale.

## When it happens

It fires when the OS locale data has changed under the database — for example after an operating-system or C-library upgrade that altered locale definitions — so the collation version recorded for the database no longer matches.

## How to fix

This warns that text sort order may have shifted. Rebuild affected indexes on text columns with `REINDEX`, then refresh the recorded collation version. Follow the documented collation-version mismatch procedure for your version. Ignoring it risks incorrect results from indexes built under the previous locale.

## Example

*Illustrative* — the OS locale changed under the database.

```text
FATAL:  database locale is incompatible with operating system
DETAIL:  The database was initialized with LC_COLLATE "en_US.utf8", which is not recognized by setlocale().
```

## Related

- [current database's encoding is not supported with this provider](./current-database-s-encoding-is-not-supported-with-this-provider.md)
- [data directory has wrong ownership](./data-directory-has-wrong-ownership.md)
