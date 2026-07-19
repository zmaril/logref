---
message: "%s(%s) not supported"
slug: not-supported
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:1792"
  - "postgres/src/backend/libpq/pqcomm.c:1867"
  - "postgres/src/backend/libpq/pqcomm.c:1942"
reproduced: false
---

# `%s(%s) not supported`

## What it means

A log message noting that a particular protocol or socket operation is not supported in the current context. It records that the server declined an operation the platform or protocol state does not allow, naming the operation.

## When it happens

During connection handling when an operation the client or protocol requested is not available — for example a socket feature the platform lacks, logged rather than treated as a hard failure.

## Is this a problem?

Usually informational. Read which operation was declined; if a client depends on it, check whether the platform or build supports that feature and whether the connection settings request something unavailable. In many cases the server proceeds without the unsupported operation.

## Example

*Illustrative* — an unsupported socket operation.

```text
LOG:  getpeereid(sock) not supported
```

## Related

- [unrecognized ssl error code](./unrecognized-ssl-error-code.md)
- [could not open shared memory segment](./could-not-open-shared-memory-segment.md)
