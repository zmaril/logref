-- Array / row / range / composite errors  ->  src/backend/utils/adt/{arrayfuncs,rowtypes,rangetypes}.c
-- Dimension mismatches, subscript faults, malformed range/multirange literals,
-- and composite-type coercion errors.

SELECT (ARRAY[1,2,3])[0:100][1];
SELECT ARRAY[[1,2],[3]];
SELECT ARRAY[1,2] || ARRAY[['a']];
SELECT array_fill(0, ARRAY[-1]);
SELECT array_fill(0, ARRAY[1,2], ARRAY[1]);
SELECT array_dims(ARRAY[]::int[]);
SELECT (ARRAY[1,2,3])[1:2] = ARRAY['a'];
SELECT array_cat(ARRAY[1], ARRAY['a']);
SELECT array_append(ARRAY[1,2], 'x');
SELECT array_position(ARRAY[1,2,3], 'x');
SELECT array_upper(1, 1);
SELECT '{1,2,3}'::int[] + '{1}'::int[];
SELECT unnest(ARRAY[1,2], ARRAY[1,2,3]);
SELECT array_agg(id ORDER BY nope) FROM repro.parent;
SELECT '(1,2,3)'::repro.parent;
SELECT ROW(1,2)::repro.parent;
SELECT (ROW(1, 'a')::repro.parent).nope;
SELECT '(1)'::repro.parent;
SELECT 'notarange'::int4range;
SELECT int4range(10, 1);
SELECT '[1,2)'::int4range * '[5,6)'::int4range + '[1,2)'::int4range;
SELECT lower('empty'::int4range::text::int4range);
SELECT int4multirange(int4range(1,5), int4range(3,7)) - 1;
SELECT range_merge(int4range(1,2), int4range(5,6)) - int4range(1,2);
SELECT '{1,2,3'::int[];
SELECT '[1:2]={1,2,3}'::int[];
SELECT numrange(1,2) @> 'x';
SELECT tstzrange('2020-01-01', '2019-01-01');
SELECT array_length(ARRAY[1,2,3], 0);
SELECT (ARRAY[1,2,3])[1:2][1:2][1:2] || 'x';
SELECT slice_bug FROM (SELECT (ARRAY[1])[5]) t(slice_bug) WHERE slice_bug = 1;
SELECT cardinality(ARRAY[1,2]) / 0;
