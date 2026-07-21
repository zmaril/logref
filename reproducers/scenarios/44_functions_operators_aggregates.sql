-- Function and operator resolution / coercion errors.
--   Function resolution      -> src/backend/parser/parse_func.c
--   Operator resolution      -> src/backend/parser/parse_oper.c
--   Type coercion            -> src/backend/parser/parse_coerce.c
--   Name/namespace lookup    -> src/backend/catalog/namespace.c
--   A few runtime arg errors  -> src/backend/utils/adt/** (format, date, etc.)

-- Non-existent function (function ... does not exist).
SELECT no_such_fn(1);
SELECT repro.no_such_fn();
-- Wrong number of arguments to a real function (no matching signature).
SELECT length();
SELECT abs(1, 2);
SELECT upper();
SELECT lower('a', 'b');
-- Wrong argument type with no implicit cast (function does not exist for type).
SELECT abs('foo'::text);
SELECT sqrt('bar'::text);
SELECT repro.addone('notanint'::text);
-- Ambiguous function call: two overloads reachable by implicit cast.
CREATE FUNCTION repro.ambi(int) RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.ambi(bigint) RETURNS int LANGUAGE sql AS 'SELECT 2';
SELECT repro.ambi('7'::smallint);
-- Undefined operator between types.
SELECT 1 # '{}'::json;
SELECT true + true;
SELECT '{}'::json = '{}'::json;
SELECT 'a'::text - 'b'::text;
SELECT '{}'::json < '{}'::json;
SELECT point '(1,1)' + 'x'::text;
-- Ambiguous operator (two candidate operators via implicit cast).
CREATE FUNCTION repro.ambiop(int, int) RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE FUNCTION repro.ambiop(bigint, bigint) RETURNS int LANGUAGE sql AS 'SELECT 2';
CREATE OPERATOR repro.## (LEFTARG=int, RIGHTARG=int, PROCEDURE=repro.ambiop);
CREATE OPERATOR repro.## (LEFTARG=bigint, RIGHTARG=bigint, PROCEDURE=repro.ambiop);
SELECT '1'::smallint OPERATOR(repro.##) '2'::smallint;
-- Explicit OPERATOR() with incompatible operand types.
SELECT 1 OPERATOR(pg_catalog.+) 'x';
SELECT 1 OPERATOR(pg_catalog.||) 2;
-- Coercion / CAST failures at the type-system level.
SELECT CAST(ROW(1,2) AS int);
SELECT CAST(ROW(1,2) AS boolean);
SELECT NULLIF(1, 'x'::json);
SELECT COALESCE(1, '{}'::json);
SELECT CASE WHEN true THEN 1 ELSE '{}'::json END;
-- Set operation with non-matching / non-coercible column types.
SELECT 1 UNION SELECT '{}'::json;
-- Function-in-FROM misuse: scalar function used as a table source.
SELECT * FROM abs(1);
SELECT * FROM repro.addone(1);
-- Set-returning function with wrong argument count.
SELECT * FROM generate_series(1);
SELECT * FROM generate_series();
-- Column-definition list mismatch for a record-returning function.
SELECT * FROM json_to_record('{"a":1}') AS x;
-- VARIADIC misuse and too-few args.
SELECT concat_ws();
SELECT format();
SELECT num_nonnulls();
SELECT VARIADIC ARRAY[1,2];
-- VARIADIC with a non-array argument.
SELECT concat(VARIADIC 7);
-- Named-argument errors.
SELECT abs(x => 1);
SELECT repro.addone(n => 1);
SELECT length(str => 'a', str => 'b');
SELECT format('%s', p => 1);
-- Positional argument after a named argument.
SELECT btrim(str => 'xax', 'x');
-- Runtime function-argument errors (adt).
SELECT make_date(2020, 13, 40);
SELECT make_time(25, 61, 0);
SELECT to_date('2020-99-99', 'YYYY-MM-DD');
SELECT chr(-1);
SELECT repeat('x', -1) IS NULL;
SELECT substring('abc' FROM 1 FOR -1);
SELECT format('%2$s', 'only-one');
SELECT format('%z', 1);
SELECT ('{}'::json) -> 0 -> 'x' -> 'y' -> 999999999999;
-- ANY/ALL (array) operator misuse.
SELECT 1 = ANY(2);
SELECT 1 + ANY(ARRAY[1,2]);
-- DISTINCT / ORDER BY on a type with no equality / ordering operator.
SELECT DISTINCT '(1,2)'::point;
SELECT array_agg(x ORDER BY x) FROM (SELECT '(1,2)'::point AS x) s;

-- Aggregate, window-function and set-returning-function placement errors.
--   Aggregate/window/grouping parse checks -> src/backend/parser/parse_agg.c
--   Aggregate execution                    -> src/backend/executor/nodeAgg.c
--   Set-returning function execution       -> src/backend/executor/execSRF.c
--   SRF / composite return support         -> src/backend/utils/fmgr/funcapi.c

-- Aggregate in a disallowed clause.
SELECT * FROM repro.parent WHERE count(*) > 1;
SELECT * FROM repro.parent GROUP BY count(*);
SELECT id FROM repro.parent GROUP BY id HAVING count(*) > count(sum(id));
UPDATE repro.parent SET label = 'x' WHERE count(*) > 0;
-- Nested aggregate calls.
SELECT sum(count(*)) FROM repro.parent;
SELECT max(avg(id)) FROM repro.parent;
-- Aggregate in the argument of another aggregate via FILTER.
SELECT sum(id) FILTER (WHERE count(*) > 0) FROM repro.parent;
-- Aggregate in a JOIN/ON condition (disallowed).
SELECT * FROM repro.parent p JOIN repro.child c ON count(*) > 0;
-- Nested aggregate in the direct arguments of an ordered-set aggregate.
SELECT percentile_cont(avg(id)) WITHIN GROUP (ORDER BY id) FROM repro.parent;
-- Aggregate directly containing a window-function call.
SELECT sum(rank() OVER ()) FROM repro.parent;
-- Aggregate in a recursive query's recursive term.
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT count(*) FROM t) SELECT * FROM t;
-- Correlated subquery references an ungrouped outer column.
SELECT (SELECT p.id) FROM repro.parent p GROUP BY p.label;
-- Window function in a disallowed clause.
SELECT * FROM repro.parent WHERE rank() OVER () > 1;
SELECT id FROM repro.parent GROUP BY id, rank() OVER ();
SELECT id, count(*) FROM repro.parent GROUP BY id HAVING rank() OVER () > 1;
-- Nested window function calls.
SELECT rank() OVER (ORDER BY rank() OVER ()) FROM repro.parent;
SELECT lag(rank() OVER ()) OVER () FROM repro.parent;
-- Reference to an undefined named window.
SELECT rank() OVER w FROM repro.parent;
-- Aggregate used as a window function argument that nests another aggregate.
SELECT sum(sum(id)) OVER () FROM repro.parent;
-- Window function without an OVER clause.
SELECT rank() FROM repro.parent;
SELECT row_number() FROM repro.parent;
SELECT lag(id) FROM repro.parent;
-- OVER clause on a plain (non-window, non-aggregate) function.
SELECT abs(1) OVER () FROM repro.parent;
-- (*) / WITHIN GROUP / IGNORE NULLS on a non-aggregate function.
SELECT pg_backend_pid(*);
SELECT int4pl(1) WITHIN GROUP (ORDER BY 2);
SELECT abs(1) IGNORE NULLS FROM repro.parent;
-- ORDER BY / DISTINCT inside a non-aggregate function call.
SELECT abs(1 ORDER BY 1);
SELECT abs(DISTINCT 1);
SELECT length('x' ORDER BY 1);
-- FILTER on a non-aggregate.
SELECT abs(1) FILTER (WHERE true);
SELECT length('x') FILTER (WHERE true) FROM repro.parent;
-- WITHIN GROUP / IGNORE NULLS on an ordinary aggregate.
SELECT string_agg(label) WITHIN GROUP (ORDER BY label) FROM repro.parent;
SELECT count(id) IGNORE NULLS FROM repro.parent;
-- WITHIN GROUP on a true window function.
SELECT lag(id) WITHIN GROUP (ORDER BY id) OVER () FROM repro.parent;
-- Parameterless aggregate called without the (*) syntax.
SELECT count() FROM repro.parent;
SELECT count() OVER () FROM repro.parent;
-- DISTINCT / FILTER / SRF misuse with a window function.
SELECT count(DISTINCT id) OVER () FROM repro.parent;
SELECT row_number() FILTER (WHERE true) OVER () FROM repro.parent;
SELECT first_value(generate_series(1, 2)) OVER () FROM repro.parent;
-- WITHIN GROUP misuse.
SELECT percentile_cont(0.5) FROM repro.parent;
SELECT sum(id) WITHIN GROUP (ORDER BY id) FROM repro.parent;
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY id) OVER () FROM repro.parent;
SELECT mode() FROM repro.parent;
-- DISTINCT with an ordered-set / hypothetical aggregate.
SELECT rank(1) WITHIN GROUP (ORDER BY id) FILTER (WHERE false) FROM repro.parent;
-- GROUPING outside a grouped query.
SELECT GROUPING(id) FROM repro.parent;
SELECT GROUPING(label) FROM repro.parent GROUP BY id;
-- GROUPING with too many arguments.
SELECT GROUPING(id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id,id) FROM repro.parent GROUP BY id;
-- GROUP BY position / GROUPING SETS misuse.
SELECT id FROM repro.parent GROUP BY 5;
SELECT id, sum(id) FROM repro.parent GROUP BY GROUPING SETS ((label));
-- Set-returning function in disallowed contexts.
SELECT sum(generate_series(1, 3));
SELECT generate_series(1, 2) OVER ();
SELECT * FROM repro.parent WHERE generate_series(1, 2) > 0;
SELECT CASE WHEN true THEN generate_series(1, 3) ELSE 0 END;
SELECT COALESCE(generate_series(1, 3), 0);
SELECT id FROM repro.parent ORDER BY generate_series(1, 2);
SELECT id FROM repro.parent GROUP BY generate_series(1, 2);
SELECT generate_series(1, generate_series(1, 3));
SELECT abs(generate_series(1, 2)) FROM repro.parent WHERE id = generate_series(1, 2);
-- Set-returning function nested below the top level of a FROM item.
SELECT * FROM abs(generate_series(1, 3));
-- SRF in the argument of an aggregate.
SELECT array_agg(generate_series(1, 3));
-- SRF whose composite result is used without a column list.
SELECT generate_series(1, 2) FILTER (WHERE true);
