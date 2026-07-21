---
message: "could not open version file \"%s\": %m"
slug: could-not-open-version-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/version.c:57"
reproduced: true
---

# `could not open version file "%s": %m`

## What it means

A front-end tool tried to open the `PG_VERSION` file in a data directory and the operating system refused. The `%m` reason gives the cause. The version file records the cluster's major version.

## When it happens

It happens when a tool inspects a data directory (for example during upgrade or rewind checks), when `PG_VERSION` is missing or unreadable — usually the path does not point at a real data directory, or a permissions problem.

## How to fix

Point the tool at a genuine data directory that contains a readable `PG_VERSION`, and confirm the invoking user can read it. Correcting the data-directory path resolves it.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  could not open version file "%s": %m
```

## Related

- [could not parse version file](./could-not-parse-version-file.md)
- [could not open filter file](./could-not-open-filter-file.md)
