-- MAC/network/geometry/bit-string/tid/lsn value errors  ->  src/backend/utils/adt/{mac8,mac,network,geo_ops,varbit,tid,pg_lsn}.c
-- Targets the EUI-64 hex path, cidr/inet width mismatches, degenerate line
-- construction, bit-string length/index checks, tuple-id input, and pg_lsn
-- subtraction underflow rather than the plain unparseable-literal input lines.

-- macaddr8 / macaddr input and conversion (mac8.c, mac.c)
SELECT 'zz:zz:zz:zz:zz:zz:zz:zz'::macaddr8;
SELECT '01:02:03'::macaddr8;
SELECT (macaddr8 '00-00-00-00-00-00-00-00')::macaddr;
SELECT '01:02:03:04:05'::macaddr;
SELECT 'gg:gg:gg:gg:gg:gg'::macaddr;

-- cidr / inet width and mask edges (network.c)
SELECT set_masklen('10.0.0.0/8'::cidr, 40);
SELECT set_masklen('::/0'::cidr, 200);
SELECT '1.2.3.4'::inet - '::1'::inet;
SELECT '1.2.3.4/24'::cidr | '10.0.0.0/8'::cidr;
SELECT '1.2.3.4'::inet # '::1'::inet;

-- degenerate line construction from coincident points (geo_ops.c)
SELECT line('(1,1)'::point, '(1,1)'::point);
SELECT '(0,0),(0,0)'::line;

-- bit / varbit length mismatch and index range (varbit.c)
SELECT '12'::varbit;
SELECT '1010'::bit(6);
SELECT set_bit(B'101', -1, 1);
SELECT get_bit(B'101', -1);
SELECT overlay(B'10101' placing B'1' from -1 for 1);

-- tuple-id input (tid.c tidin, no baseline coverage)
SELECT 'nope'::tid;
SELECT '(1,2,3)'::tid;
SELECT '(1)'::tid;
SELECT '(4294967296,1)'::tid;

-- pg_lsn subtraction underflow (pg_lsn.c pg_lsn_mi)
SELECT '0/0'::pg_lsn - '1/0'::pg_lsn;
SELECT '0/0'::pg_lsn - '0/1'::pg_lsn;
