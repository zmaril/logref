---
message: "publication parameters are not applicable to sequence synchronization and will be ignored for sequences"
slug: publication-parameters-are-not-applicable-to-sequence-synchronization-and-will
passthrough: false
api: [ereport]
level: [NOTICE]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:900"
  - "postgres/src/backend/commands/publicationcmds.c:1047"
reproduced: false
---

# `publication parameters are not applicable to sequence synchronization and will be ignored for sequences`

## What it means

A notice that certain publication parameters do not apply to sequence synchronization, so they are ignored for sequences in the publication.

## When it happens

It arises when a publication that includes sequences carries parameters (for example row-oriented options) meaningful only for tables, and those are skipped for the sequence members.

## Is this a problem?

No action is needed. The parameters are ignored for sequences by design; they still apply to the publication's tables. Remove them only if they serve no purpose for your publication.

## Example

*Illustrative* — parameters ignored for sequences.

```text
NOTICE:  publication parameters are not applicable to sequence synchronization and will be ignored for sequences
```

## Related

- [collation "%s" already exists, skipping](./collation-already-exists-skipping.md)
- [operator family "%s" of access method %s is missing cross-type operator(s)](./operator-family-of-access-method-is-missing-cross-type-operator-s.md)
