-- Undefined / missing catalog objects  ->  src/backend/catalog/**, parser/parse_*.c
-- Names that resolve to nothing: tables, columns, functions, types, schemas,
-- operators, collations, roles. These are the "does not exist" ereports.

SELECT * FROM nonexistent_table;
SELECT * FROM repro.nonexistent_table;
SELECT nonexistent_column FROM repro.parent;
SELECT repro.parent.nope FROM repro.parent;
SELECT * FROM repro.parent WHERE nope = 1;
SELECT nonexistent_func(1);
SELECT repro.nonexistent_func(1);
SELECT length();
SELECT length(1, 2, 3);
SELECT * FROM nonexistent_schema.t;
CREATE TABLE nonexistent_schema.t (id int);
SELECT 1::nonexistent_type;
SELECT CAST(1 AS nonexistent_type);
SELECT 1 OPERATOR(pg_catalog.@@@@) 2;
SELECT 'x' COLLATE "nonexistent_collation";
DROP TABLE nonexistent_table;
DROP VIEW nonexistent_view;
DROP FUNCTION nonexistent_func(int);
DROP SCHEMA nonexistent_schema;
DROP TYPE nonexistent_type;
DROP INDEX nonexistent_index;
DROP SEQUENCE nonexistent_sequence;
DROP TRIGGER nope ON repro.parent;
DROP ROLE nonexistent_role;
ALTER TABLE nonexistent_table ADD COLUMN c int;
ALTER TABLE repro.parent RENAME COLUMN nope TO other;
ALTER TABLE repro.parent DROP COLUMN nope;
ALTER TABLE repro.parent ALTER COLUMN nope TYPE text;
COMMENT ON TABLE nonexistent_table IS 'x';
GRANT SELECT ON nonexistent_table TO lowpriv;
SELECT * FROM repro.parent p JOIN repro.child c ON p.nope = c.id;
SELECT setval('nonexistent_seq', 1);
SELECT nextval('nonexistent_seq');
SELECT currval('nonexistent_seq');
SELECT 'nonexistent_table'::regclass;
SELECT 'nonexistent_func(int)'::regprocedure;
SELECT 'nonexistent_type'::regtype;
SELECT 'nonexistent_op'::regoper;
SELECT to_regclass('repro.parent') IS NULL AND 1/0 = 1;
TABLE repro.nope;
SELECT * FROM pg_catalog.nonexistent_view;
ALTER FUNCTION repro.nope(int) RENAME TO other;
SELECT array_agg(nope) FROM repro.parent;
