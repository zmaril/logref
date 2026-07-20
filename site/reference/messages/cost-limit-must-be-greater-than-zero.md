---
message: "cost limit must be greater than zero"
slug: cost-limit-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:581"
reproduced: false
---

# `cost limit must be greater than zero`

## What it means

A cost-limit parameter for the data-checksum worker was given a value of zero or less. The cost limit bounds work between delays and must be positive.

## When it happens

It happens when configuring the online data-checksum operation with a non-positive cost limit.

## How to fix

Set the cost limit to a value greater than zero. Pick a positive limit that balances throughput against the load the operation places on the system.

## Example

*Illustrative* — a non-positive cost limit.

```text
ERROR:  cost limit must be greater than zero
```

## Related

- [cost delay cannot be a negative value](./cost-delay-cannot-be-a-negative-value.md)
- [configuration file contains errors](./configuration-file-contains-errors.md)
