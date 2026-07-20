---
message: "client %d aborted: end of script reached without completing the last transaction"
slug: client-aborted-end-of-script-reached-without-completing-the-last-transaction
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:4291"
reproduced: false
---

# `client %d aborted: end of script reached without completing the last transaction`

## What it means

A `pgbench` client reached the end of its script while a transaction it started was still open. The script left a transaction uncommitted, so the client is aborted.

## When it happens

It occurs during a `pgbench` run when a custom script issues `BEGIN` without a matching `COMMIT` or `ROLLBACK` before the script ends.

## How to fix

End every transaction the script opens with `COMMIT` or `ROLLBACK` before the script finishes. Balance transaction control statements in the benchmark script.

## Example

*Illustrative* — a script ending mid-transaction.

```text
pgbench: error: client 0 aborted: end of script reached without completing the last transaction
```

## Related

- [client aborted end of script reached with pipeline open](./client-aborted-end-of-script-reached-with-pipeline-open.md)
- [client aborted in command of script](./client-aborted-in-command-of-script.md)
