---
message: "cost delay cannot be a negative value"
slug: cost-delay-cannot-be-a-negative-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:576"
reproduced: false
---

# `cost delay cannot be a negative value`

## What it means

A cost-based delay parameter for the data-checksum worker was given a negative value. The delay measures a wait time, so it cannot be negative.

## When it happens

It happens when configuring the online data-checksum operation with a negative cost-delay value.

## How to fix

Set the cost delay to zero or a positive value. Choose a small non-negative number of milliseconds to throttle the operation without stalling it.

## Example

*Illustrative* — a negative cost delay.

```text
ERROR:  cost delay cannot be a negative value
```

## Related

- [cost limit must be greater than zero](./cost-limit-must-be-greater-than-zero.md)
- [configuration file contains errors](./configuration-file-contains-errors.md)
