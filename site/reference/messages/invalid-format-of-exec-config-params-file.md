---
message: "invalid format of exec config params file"
slug: invalid-format-of-exec-config-params-file
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:5630"
  - "postgres/src/backend/utils/misc/guc.c:5683"
  - "postgres/src/backend/utils/misc/guc.c:5685"
  - "postgres/src/backend/utils/misc/guc.c:5687"
  - "postgres/src/backend/utils/misc/guc.c:5689"
  - "postgres/src/backend/utils/misc/guc.c:5691"
  - "postgres/src/backend/utils/misc/guc.c:5693"
reproduced: false
---

# `invalid format of exec config params file`

## What it means

Internal/startup error. A backend started by the postmaster could not parse the serialized GUC (configuration) file passed to it. On systems without `fork` sharing (notably Windows' `EXEC_BACKEND` model), the postmaster writes configuration to a temp file for each new backend; a malformed file stops that backend from starting.

## When it happens

A transient or environmental problem in the `EXEC_BACKEND` startup path — a corrupted or truncated temp config file, a disk problem in the temp location, or a version mismatch in an unusual setup. It is rare on Unix (which normally inherits config via `fork`).

## How to fix

This is not caused by user SQL. Check the server's temp directory and disk for problems, and ensure the postmaster and backends are the same build. If it recurs, capture the server log around startup and report it — a reproducible case points at a real bug or environment fault.

## Example

*Illustrative* — a backend failing to read its config file at startup.

```text
FATAL:  invalid format of exec config params file
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
- [could not read from file](./could-not-read-from-file.md)
