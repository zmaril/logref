---
message: "cannot use \"%s\" with HEADER in COPY TO"
slug: cannot-use-with-header-in-copy-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:435"
reproduced: true
---

# `cannot use "%s" with HEADER in COPY TO`

## What it means

A `COPY TO` command combined the `HEADER` option with another option that cannot appear alongside it. The named option and a header row are mutually exclusive on output, so the combination is rejected.

## When it happens

It occurs on `COPY ... TO ... (HEADER, ...)` when a second option that conflicts with headers, such as a binary or non-text format setting, is also given.

## How to fix

Drop either the `HEADER` option or the conflicting option. Header rows apply only to text and CSV output, so remove them when using a format that does not support headers.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
COPY repro.parent TO STDOUT (FORMAT csv, HEADER match);
```

Produces:

```text
ERROR:  cannot use "match" with HEADER in COPY TO
```

## Related

- [cannot use multi-line header in COPY TO](./cannot-use-multi-line-header-in-copy-to.md)
- [cannot specify both PARSER and COPY options](./cannot-specify-both-parser-and-copy-options.md)
