---
message: "missing entry at end of line"
slug: missing-entry-at-end-of-line
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/libpq/be-secure-common.c:235"
  - "postgres/src/backend/libpq/be-secure-common.c:259"
reproduced: false
---

# `missing entry at end of line`

## What it means

A configuration-file parser found a line that ends before a required field, so the line is incomplete.

## When it happens

It arises from parsing files such as `pg_hba.conf` or `pg_ident.conf` when a line is missing a trailing field the format requires.

## Is this a problem?

Complete the offending line with the missing field, following the file's documented format. The surrounding log identifies the file and line; add the required value and reload.

## Example

*Illustrative* — an incomplete configuration line.

```text
LOG:  missing entry at end of line
```

## Related

- [invalid configuration parameter name "%s"](./invalid-configuration-parameter-name.md)
- [could not translate name](./could-not-translate-name.md)
