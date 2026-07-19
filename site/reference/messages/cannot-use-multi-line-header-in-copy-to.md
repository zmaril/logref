---
message: "cannot use multi-line header in COPY TO"
slug: cannot-use-multi-line-header-in-copy-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:468"
reproduced: false
---

# `cannot use multi-line header in COPY TO`

## What it means

A `COPY TO` command set a header option asking for more than one header line. `COPY TO` writes a single header row when headers are enabled, so a multi-line header value is not supported on output.

## When it happens

It occurs on `COPY ... TO ... (HEADER n)` with `n` greater than one, or `HEADER MATCH` used on the output side.

## How to fix

Use `HEADER` or `HEADER true` for a single header line on `COPY TO`, or omit the header. Multi-line and match headers apply only to `COPY FROM`.

## Example

*Illustrative* — a multi-line header on COPY TO.

```sql
COPY t TO '/tmp/t.csv' (HEADER 2);
-- ERROR:  cannot use multi-line header in COPY TO
```

## Related

- [cannot specify both PARSER and COPY options](./cannot-specify-both-parser-and-copy-options.md)
- [cannot use](./cannot-use.md)
