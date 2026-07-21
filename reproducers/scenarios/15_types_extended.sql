-- Extended type input, typmod, range and overflow errors.
-- bit/varbit
SELECT B'101'::bit(2);
SELECT '101'::varbit(2)::bit(5);
SELECT bit_length('x'::bit(3));
SELECT get_bit('101'::bit(3), 9);
SELECT set_bit('101'::bit(3), 9, 1);
SELECT get_byte('\x1234'::bytea, 99);
SELECT set_byte('\x1234'::bytea, 99, 0);
SELECT overlay('101'::bit(3) placing '11'::bit(2) from 0);
SELECT '101'::bit(3) & '11'::bit(2);
SELECT '101'::bit(3) # '1'::bit(1);
-- char/varchar length
SELECT 'abcdef'::char(3)::varchar(2);
SELECT 'toolong'::varchar(3);
SELECT repeat('a', 5)::char(2)::text || 'x'::varchar(1) || 'yy'::varchar(1);
SELECT 'abc'::char(2)::"char"::text::varchar(1);
-- numeric typmod
SELECT 123.456::numeric(4,2);
SELECT 12345::numeric(3);
SELECT 1.5::numeric(-1);
SELECT 1.5::numeric(1000000);
SELECT (10 ^ 131072)::numeric;
SELECT 12345.678::decimal(5,4);
-- int typmod / overflow
SELECT 2147483648::int4;
SELECT (-2147483649)::int4;
SELECT 9223372036854775808::int8;
SELECT 32768::int2;
SELECT (-32769)::int2;
SELECT 256::int2 * 256::int2 * 256::int2;
SELECT int4(2)^31::int;
SELECT abs((-2147483648)::int4);
SELECT (-2147483648)::int4 * (-1);
SELECT 2147483647::int4 + 1;
SELECT 9223372036854775807 + 1;
SELECT (-9223372036854775808)::int8 / (-1);
-- money
SELECT '92233720368547758.08'::money;
SELECT '$1e10'::money;
SELECT 'abc'::money;
SELECT '9223372036854775807'::money + '1'::money;
-- oid/xid
SELECT '4294967296'::oid;
SELECT '-1'::xid8;
SELECT 'notxid'::xid;
SELECT 'notlsn'::pg_lsn;
SELECT 'FFFFFFFF/FFFFFFFF'::pg_lsn + 1;
-- uuid
SELECT '{12345}'::uuid;
SELECT 'gggggggg-gggg-gggg-gggg-gggggggggggg'::uuid;
-- bytea escape
SELECT '\x123'::bytea;
SELECT '\777'::bytea;
SELECT '\q'::bytea;
SELECT decode('zz', 'hex');
SELECT decode('a', 'base64');
SELECT encode('x'::bytea, 'nosuch');
