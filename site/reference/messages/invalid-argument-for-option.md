---
message: "invalid argument for option %s"
slug: invalid-argument-for-option
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:404"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:192"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:204"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:218"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:232"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:239"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:259"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:273"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:281"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:302"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:312"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:347"
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:188"
  - "postgres/src/bin/pg_upgrade/option.c:230"
reproduced: false
---

# `invalid argument for option %s`

## What it means

A command-line tool was given an option whose value it could not accept — the wrong kind of value for that flag (for example a non-numeric string where a number is required, or an unrecognized keyword). The placeholder is the option name.

## When it happens

Passing a bad value to a flag of a utility such as `pg_amcheck`, `pg_resetwal`, `pg_test_fsync`, or a foreign-data option — for instance `-j abc` where a job count is expected, or an option keyword the tool does not know.

## How to fix

Check the tool's `--help` for the option's expected value type and allowed keywords, then supply a valid value. Numeric options need numbers; enumerated options need one of the documented keywords. The message names the option so you know which argument to correct.

## Example

*Illustrative* — a non-numeric value for a numeric option.

```sh
pg_amcheck --jobs=lots mydb
```

Produces:

```text
pg_amcheck: error: invalid argument for option --jobs
```

## Related

- [options %s and %s cannot be used together](./options-and-cannot-be-used-together-8b5f2b.md)
- [Try "%s --help" for more information](./try-help-for-more-information-c0987f.md)
