---
message: "cannot set comment on relation \"%s\""
slug: cannot-set-comment-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/comment.c:109"
reproduced: false
---

# `cannot set comment on relation "%s"`

## What it means

A `COMMENT ON` targeted a relation whose kind does not support comments in that form. The relation is of a type that cannot carry the requested comment. The placeholder is the relation name.

## When it happens

It occurs when `COMMENT ON` names an object kind not accepted by that comment target, such as commenting on an object with the wrong `COMMENT ON` variant.

## How to fix

Use the `COMMENT ON` variant that matches the object's kind (for example `COMMENT ON VIEW`, `COMMENT ON SEQUENCE`), and confirm the object supports comments. Choose the correct object type in the command.

## Example

*Illustrative* — an unsupported COMMENT ON target.

```text
ERROR:  cannot set comment on relation "my_obj"
```

## Related

- [cannot set options for relation](./cannot-set-options-for-relation.md)
- [cannot set security label on relation](./cannot-set-security-label-on-relation.md)
