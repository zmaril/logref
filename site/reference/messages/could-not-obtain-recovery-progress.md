---
message: "could not obtain recovery progress: %s"
slug: could-not-obtain-recovery-progress
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:964"
reproduced: false
---

# `could not obtain recovery progress: %s`

## What it means

`pg_createsubscriber` queried the standby it is converting for its recovery progress and the query failed. The `%s` value gives the reason. It tracks how far recovery has advanced to coordinate the conversion.

## When it happens

It happens during subscriber setup while checking the target standby's recovery position, when that query fails — usually a connection problem or a standby that is not in the expected state.

## How to fix

Confirm the connection to the standby works and the standby is running in recovery as expected, then rerun. The included reason usually names the cause.

## Example

*Illustrative* — the recovery-progress query failed.

```text
pg_createsubscriber: error: could not obtain recovery progress: connection to server failed
```

## Related

- [could not obtain recovery progress from the publisher](./could-not-obtain-recovery-progress-from-the-publisher.md)
- [could not obtain publisher settings](./could-not-obtain-publisher-settings.md)
