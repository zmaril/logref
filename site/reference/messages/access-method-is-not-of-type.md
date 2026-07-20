---
message: "access method \"%s\" is not of type %s"
slug: access-method-is-not-of-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/index/amapi.c:94"
  - "postgres/src/backend/commands/amcmds.c:141"
reproduced: false
---

# `access method "%s" is not of type %s`

## What it means

A command referenced an access method of the wrong kind. Access methods come in kinds — table access methods and index access methods — and the named method is not the kind the command requires.

## When it happens

Using an access-method name where the other kind is expected — for example naming a table access method in an index context, or naming an index access method where a table access method belongs.

## How to fix

Name an access method of the correct kind. List access methods with `\dA` in psql, which shows each method's type, and choose one matching the command. Confirm any custom access method is registered as the kind you intend to use.

## Example

*Illustrative* — an access method of the wrong kind.

```sql
CREATE INDEX ON t USING heap (c);  -- heap is a table access method, not an index one
```

## Related

- [operator class does not exist for access method](./operator-class-does-not-exist-for-access-method.md)
- [access method does not exist](./access-method-does-not-exist.md)
