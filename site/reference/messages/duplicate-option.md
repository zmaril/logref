---
message: "duplicate option \"%s\""
slug: duplicate-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:733"
  - "postgres/src/backend/backup/basebackup.c:742"
  - "postgres/src/backend/backup/basebackup.c:753"
  - "postgres/src/backend/backup/basebackup.c:770"
  - "postgres/src/backend/backup/basebackup.c:779"
  - "postgres/src/backend/backup/basebackup.c:788"
  - "postgres/src/backend/backup/basebackup.c:803"
  - "postgres/src/backend/backup/basebackup.c:820"
  - "postgres/src/backend/backup/basebackup.c:829"
  - "postgres/src/backend/backup/basebackup.c:841"
  - "postgres/src/backend/backup/basebackup.c:865"
  - "postgres/src/backend/backup/basebackup.c:879"
  - "postgres/src/backend/backup/basebackup.c:890"
  - "postgres/src/backend/backup/basebackup.c:901"
  - "postgres/src/backend/backup/basebackup.c:914"
reproduced: false
---

# `duplicate option "%s"`

## What it means

An option was specified more than once in a command's option list. The placeholder is the repeated option name. Postgres rejects the duplicate rather than picking one occurrence, to avoid ambiguity.

## When it happens

Repeating a keyword in a `WITH (...)` clause or a utility's option list — for example listing the same backup or `COPY` option twice, or duplicating a replication command option.

## How to fix

Remove the repeated option so each appears at most once. If you meant to set two different values, that is not possible — decide which one you want and keep only that.

## Example

*Illustrative* — a repeated option in a command.

```text
ERROR:  duplicate option "format"
```

## Related

- [conflicting or redundant options](./conflicting-or-redundant-options.md)
- [option not recognized](./option-not-recognized.md)
