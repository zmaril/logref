---
message: "Try \"%s --help\" for more information."
slug: try-help-for-more-information-c0987f
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:186"
  - "postgres/contrib/oid2name/oid2name.c:195"
  - "postgres/contrib/vacuumlo/vacuumlo.c:524"
  - "postgres/contrib/vacuumlo/vacuumlo.c:533"
  - "postgres/src/bin/initdb/initdb.c:2765"
  - "postgres/src/bin/initdb/initdb.c:3305"
  - "postgres/src/bin/initdb/initdb.c:3431"
  - "postgres/src/bin/initdb/initdb.c:3451"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:447"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:469"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:247"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:335"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:355"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:367"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:374"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2562"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2574"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2596"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2608"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2614"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2666"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2677"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2687"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2693"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2700"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2712"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2724"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2732"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2745"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2751"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2760"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2772"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2783"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2791"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2413"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2436"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2446"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2454"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2482"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2562"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:748"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:760"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:767"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:776"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:783"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:793"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:863"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:875"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:885"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:892"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:899"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:906"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:913"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:920"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:927"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:936"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:943"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:511"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:527"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:537"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:545"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:226"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:234"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:139"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:157"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:164"
  - "postgres/src/bin/pg_dump/pg_backup_utils.c:95"
  - "postgres/src/bin/pg_dump/pg_dump.c:804"
  - "postgres/src/bin/pg_dump/pg_dump.c:821"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:384"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:394"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:404"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:413"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:421"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:438"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:540"
  - "postgres/src/bin/pg_dump/pg_restore.c:326"
  - "postgres/src/bin/pg_dump/pg_restore.c:342"
  - "postgres/src/bin/pg_dump/pg_restore.c:357"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:193"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:205"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:219"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:233"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:240"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:260"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:274"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:282"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:303"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:313"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:348"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:357"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:370"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:377"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:233"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:241"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:248"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:255"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:262"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:270"
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:189"
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:201"
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:210"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:236"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:245"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:256"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1544"
  - "postgres/src/bin/pg_walsummary/pg_walsummary.c:86"
  - "postgres/src/bin/pg_walsummary/pg_walsummary.c:94"
  - "postgres/src/bin/pgbench/pgbench.c:7143"
  - "postgres/src/bin/pgbench/pgbench.c:7210"
  - "postgres/src/bin/psql/startup.c:728"
  - "postgres/src/bin/scripts/clusterdb.c:113"
  - "postgres/src/bin/scripts/clusterdb.c:132"
  - "postgres/src/bin/scripts/createdb.c:149"
  - "postgres/src/bin/scripts/createdb.c:168"
  - "postgres/src/bin/scripts/createuser.c:195"
  - "postgres/src/bin/scripts/createuser.c:210"
  - "postgres/src/bin/scripts/dropdb.c:104"
  - "postgres/src/bin/scripts/dropdb.c:113"
  - "postgres/src/bin/scripts/dropdb.c:121"
  - "postgres/src/bin/scripts/dropuser.c:95"
  - "postgres/src/bin/scripts/dropuser.c:110"
  - "postgres/src/bin/scripts/dropuser.c:123"
  - "postgres/src/bin/scripts/pg_isready.c:97"
  - "postgres/src/bin/scripts/pg_isready.c:111"
  - "postgres/src/bin/scripts/reindexdb.c:184"
  - "postgres/src/bin/scripts/reindexdb.c:203"
  - "postgres/src/bin/scripts/vacuumdb.c:216"
  - "postgres/src/bin/scripts/vacuumdb.c:236"
reproduced: true
---

# `Try "%s --help" for more information.`

## What it means

A command-line program rejected its arguments and is pointing you at its own `--help` output. The placeholder is the program name (`argv[0]`). This is the standard tail line printed after almost any usage error from a Postgres client or server binary.

## When it happens

Passing an unknown option, a missing option argument, or too many positional arguments to a tool such as `psql`, `pg_dump`, `createdb`, `initdb`, or the `postgres` binary itself. The specific complaint is printed on the line above; this line just tells you where to look for valid usage.

## How to fix

Run the program with `--help` to see accepted options, then correct the offending argument. Read the error line immediately above this one — it names the exact option or argument that was wrong. For full documentation use `man <program>` or the online reference.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  Try "%s --help" for more information.
```

## Related

- [too many command-line arguments](./too-many-command-line-arguments-first-is-c4e086.md)
- [invalid argument for option](./invalid-argument-for-option.md)
