---
message: "cannot use the \"%s\" option when performing full vacuum"
slug: cannot-use-the-option-when-performing-full-vacuum
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:284"
reproduced: false
---

# `cannot use the "%s" option when performing full vacuum`

## What it means

`vacuumdb` was given an option that a full vacuum does not support, together with `--full`. The named option applies only to a plain vacuum, so combining it with a full vacuum is rejected.

## When it happens

It occurs with `vacuumdb --full` when an incompatible option such as `--parallel` is also on the command line, because a full vacuum rewrites the table and cannot run those phases in parallel.

## How to fix

Drop the conflicting option when running `--full`, or drop `--full` if you need the option. Run the two kinds of vacuum in separate `vacuumdb` invocations.

## Example

*Illustrative* — an unsupported option with a full vacuum.

```text
vacuumdb: error: cannot use the "parallel" option when performing full vacuum
```

## Related

- [cannot use multiple jobs to reindex system catalogs](./cannot-use-multiple-jobs-to-reindex-system-catalogs.md)
- [cannot specify both --single-transaction and multiple jobs](./cannot-specify-both-single-transaction-and-multiple-jobs.md)
