---
message: "COPY %s cannot be used with %s"
slug: copy-cannot-be-used-with
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:484"
  - "postgres/src/backend/commands/copy.c:926"
  - "postgres/src/backend/commands/copy.c:942"
  - "postgres/src/backend/commands/copy.c:959"
  - "postgres/src/backend/commands/copy.c:985"
  - "postgres/src/backend/commands/copy.c:1006"
reproduced: true
---

# `COPY %s cannot be used with %s`

## What it means

A `COPY` command combined `COPY` with something it does not support. The two placeholders name the `COPY` variant and the incompatible feature. Certain `COPY` forms cannot be used together — for example `COPY (query)` with a column list, or `COPY ... TO` with options that only apply to `FROM`.

## When it happens

A `COPY` statement mixing incompatible pieces: a column list on a `COPY (SELECT ...)` source, a `FROM`-only option on a `TO`, `FREEZE` outside the allowed conditions, or `COPY` with a feature its direction does not support.

## How to fix

Remove the incompatible combination. If you need to select specific columns from a query, put them in the `SELECT` inside `COPY (SELECT col1, col2 FROM ...)` rather than a column list. Match options to the direction (`FROM` vs `TO`). Consult the `COPY` documentation for which combinations are allowed.

## Example

*Reproduced* — captured from `reproducers/scenarios/34_guc_vacuum_copy_xml.sql`.

```sql
COPY repro.parent TO STDOUT WITH (FORMAT csv, FORCE_QUOTE *, FORCE_NOT_NULL (id));
```

Produces:

```text
ERROR:  COPY FORCE_NOT_NULL cannot be used with COPY TO
```

## Related

- [conflicting or redundant options](./conflicting-or-redundant-options.md)
- [option not recognized](./option-not-recognized.md)
