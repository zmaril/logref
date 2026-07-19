---
message: "transaction ID (-c) must be either %u or greater than or equal to %u"
slug: transaction-id-c-must-be-either-or-greater-than-or-equal-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:246"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:250"
reproduced: false
---

# `transaction ID (-c) must be either %u or greater than or equal to %u`

## What it means

A `pgbench` invocation gave the `-c` (client count) or a related transaction-id argument a value that violates its constraint. The placeholders show the required values. The argument must be a specific value or at least a minimum.

## When it happens

It arises from `pgbench` when an argument controlling clients/transactions is set below the required threshold or to an invalid value.

## How to fix

Read the two values the message reports and choose a valid one — either the exact permitted value or a number at or above the stated minimum. Adjust the `pgbench` command-line accordingly.

## Example

*Illustrative* — an out-of-bounds pgbench argument.

```text
FATAL:  transaction ID (-c) must be either 0 or greater than or equal to 1
```

## Related

- [Perhaps you need to do initialization ("pgbench -i") in database "%s".](./perhaps-you-need-to-do-initialization-pgbench-i-in-database.md)
- [Reduce number of clients, or use limit/ulimit to increase the system limit.](./reduce-number-of-clients-or-use-limit-ulimit-to-increase-the-system-limit.md)
