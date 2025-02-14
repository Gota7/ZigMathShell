const Implementation = @import("implementation.zig").Implementation;
const std = @import("std");

/// Built-in implementation for floating-point numbers.
fn BuiltinImplementationFloat(comptime Element: type) type {
    return struct {
        const Vec2 = [2]Element;
        const Vec3 = [3]Element;
        const Vec4 = [4]Element;
        const Vec2V = @Vector(2, Element);
        const Vec3V = @Vector(3, Element);
        const Vec4V = @Vector(4, Element);

        inline fn elem_abs(a: Element) Element {
            return @abs(a);
        }

        inline fn elem_add(a: Element, b: Element) Element {
            return a + b;
        }

        inline fn elem_approx_eq(a: Element, b: Element, c: Element) bool {
            return @abs(a - b) <= c;
        }

        inline fn elem_ceil(a: Element) Element {
            return @ceil(a);
        }

        inline fn elem_cmpxchg_strong(ptr: *Element, expected_value: Element, new_value: Element, success_order: std.builtin.AtomicOrder, fail_order: std.builtin.AtomicOrder) ?Element {
            return @cmpxchgStrong(Element, ptr, expected_value, new_value, success_order, fail_order);
        }

        inline fn elem_cmpxchg_weak(ptr: *Element, expected_value: Element, new_value: Element, success_order: std.builtin.AtomicOrder, fail_order: std.builtin.AtomicOrder) ?Element {
            return @cmpxchgWeak(Element, ptr, expected_value, new_value, success_order, fail_order);
        }

        inline fn elem_cos(a: Element) Element {
            return @cos(a);
        }

        inline fn elem_div(a: Element, b: Element) Element {
            return a / b;
        }

        inline fn elem_eq(a: Element, b: Element) bool {
            return a == b;
        }

        inline fn elem_exp(a: Element) Element {
            return @exp(a);
        }

        inline fn elem_exp2(a: Element) Element {
            return @exp2(a);
        }

        inline fn elem_floor(a: Element) Element {
            return @floor(a);
        }

        inline fn elem_from_float(a: anytype) Element {
            return @floatCast(a);
        }

        inline fn elem_from_int(a: anytype) Element {
            return @floatFromInt(a);
        }

        inline fn elem_ge(a: Element, b: Element) bool {
            return a >= b;
        }

        inline fn elem_gt(a: Element, b: Element) bool {
            return a > b;
        }

        inline fn elem_le(a: Element, b: Element) bool {
            return a <= b;
        }

        inline fn elem_log(a: Element) Element {
            return @log(a);
        }

        inline fn elem_log2(a: Element) Element {
            return @log2(a);
        }

        inline fn elem_log10(a: Element) Element {
            return @log10(a);
        }

        inline fn elem_lt(a: Element, b: Element) bool {
            return a < b;
        }

        inline fn elem_mad(a: Element, b: Element, c: Element) Element {
            return a * b + c;
        }

        inline fn elem_max(a: Element, b: Element) Element {
            return @max(a, b);
        }

        inline fn elem_min(a: Element, b: Element) Element {
            return @min(a, b);
        }

        inline fn elem_mod(a: Element, b: Element) Element {
            return a % b;
        }

        inline fn elem_mul(a: Element, b: Element) Element {
            return a * b;
        }

        inline fn elem_ne(a: Element, b: Element) bool {
            return a != b;
        }

        inline fn elem_neg(a: Element) Element {
            return -a;
        }

        inline fn elem_pow(a: Element, b: Element) Element {
            return std.math.pow(Element, a, b);
        }

        inline fn elem_rem(a: Element, b: Element) Element {
            return @rem(a, b);
        }

        inline fn elem_round(a: Element) Element {
            return @round(a);
        }

        inline fn elem_sin(a: Element) Element {
            return @sin(a);
        }

        inline fn elem_sqrt(a: Element) Element {
            return @sqrt(a);
        }

        inline fn elem_sub(a: Element, b: Element) Element {
            return a - b;
        }

        inline fn elem_tan(a: Element) Element {
            return @tan(a);
        }

        inline fn elem_trunc(a: Element) Element {
            return @trunc(a);
        }

        inline fn vec2_add(a: Vec2, b: Vec2) Vec2 {
            return @as(Vec2V, a) + @as(Vec2V, b);
        }

        inline fn vec2_approx_eq(a: Vec2, b: Vec2, c: Element) bool {
            const diff = a - b;
            return @reduce(.Min, @as(Vec2V, @splat(c)) - @abs(diff)) >= 0;
        }

        inline fn vec2_div(a: Vec2, b: Element) Vec2 {
            return a / @as(Vec2V, @splat(b));
        }

        inline fn vec2_dot(a: Vec2, b: Vec2) Element {
            return @reduce(.Add, @as(Vec2V, a) * @as(Vec2V, b));
        }

        inline fn vec2_eq(a: Vec2, b: Vec2) bool {
            return a[0] == b[0] and a[1] == b[1];
        }

        inline fn vec2_len(a: Vec2) Element {
            return @sqrt(@reduce(.Add, @as(Vec2V, a) * @as(Vec2V, a)));
        }

        inline fn vec2_len_squared(a: Vec2) Element {
            return @reduce(.Add, @as(Vec2V, a) * @as(Vec2V, a));
        }

        inline fn vec2_mad(a: Vec2, b: Element, c: Vec2) Vec2 {
            return @mulAdd(Vec2V, @as(Vec2V, a), @as(Vec2V, @splat(b)), @as(Vec2V, c));
        }

        inline fn vec2_max(a: Vec2, b: Vec2) Vec2 {
            return @max(@as(Vec2V, a), @as(Vec2V, b));
        }

        inline fn vec2_min(a: Vec2, b: Vec2) Vec2 {
            return @min(@as(Vec2V, a), @as(Vec2V, b));
        }

        inline fn vec2_mul(a: Vec2, b: Element) Vec2 {
            return @as(Vec2V, a) * @as(Vec2V, @splat(b));
        }

        inline fn vec2_ne(a: Vec2, b: Vec2) bool {
            return a[0] != b[0] or a[1] != b[1];
        }

        inline fn vec2_neg(a: Vec2) Element {
            return -@as(Vec2V, a);
        }

        inline fn vec2_normalize(a: Vec2) Vec2 {
            return @as(Vec2V, a) / @as(Vec2V, @splat(@sqrt(@reduce(.Add, @as(Vec2V, a) * @as(Vec2V, a)))));
        }

        inline fn vec2_rem(a: Vec2, b: Element) Vec2 {
            return @rem(@as(Vec2V, a), @as(Vec2V, @splat(b)));
        }

        inline fn vec2_sub(a: Vec2, b: Vec2) Vec2 {
            return @as(Vec2V, a) - @as(Vec2V, b);
        }

        inline fn vec3_add(a: Vec3, b: Vec3) Vec3 {
            return @as(Vec3V, a) + @as(Vec3V, b);
        }

        inline fn vec3_approx_eq(a: Vec3, b: Vec3, c: Element) bool {
            const diff = @as(Vec3V, a) - @as(Vec3V, b);
            return @reduce(.Min, @as(Vec3V, @splat(c)) - @abs(diff)) >= 0;
        }

        inline fn vec3_cross(a: Vec3, b: Vec3) Vec3 {
            // { a.y * b.z - a.z * b.y, -a.x * b.z + a.z * b.x, a.x * b.y - a.y * b.x }
            const pos_terms = @shuffle(Element, @as(Vec3V, a), undefined, [_]u2{ 2, 0, 1 }) * @as(Vec3V, b); // a.z * b.x, a.x * b.y, a.y * b.z
            const neg_terms = @shuffle(Element, @as(Vec3V, a), undefined, [_]u2{ 1, 2, 0 }) * @as(Vec3V, b); // a.y * b.x, a.z * b.y, a.x * b.z
            return @shuffle(Element, pos_terms, undefined, [_]u2{ 2, 0, 1 }) - @shuffle(Element, neg_terms, undefined, [_]u2{ 1, 2, 0 });
        }

        inline fn vec3_div(a: Vec3, b: Element) Vec3 {
            return @as(Vec3V, a) / @as(Vec3V, @splat(b));
        }

        inline fn vec3_dot(a: Vec3, b: Vec3) Element {
            return @reduce(.Add, @as(Vec3V, a) * @as(Vec3V, b));
        }

        inline fn vec3_eq(a: Vec3, b: Vec3) bool {
            return a[0] == b[0] and a[1] == b[1] and a[2] == b[2];
        }

        inline fn vec3_len(a: Vec3) Element {
            return @sqrt(@reduce(.Add, @as(Vec3V, a) * @as(Vec3V, a)));
        }

        inline fn vec3_len_squared(a: Vec3) Element {
            return @reduce(.Add, @as(Vec3V, a) * @as(Vec3V, a));
        }

        inline fn vec3_mad(a: Vec3, b: Element, c: Vec3) Vec3 {
            return @mulAdd(Vec3V, @as(Vec3V, a), @splat(b), @as(Vec3V, c));
        }

        inline fn vec3_max(a: Vec3, b: Vec3) Vec3 {
            return @max(@as(Vec3V, a), @as(Vec3V, b));
        }

        inline fn vec3_min(a: Vec3, b: Vec3) Vec3 {
            return @min(@as(Vec3V, a), @as(Vec3V, b));
        }

        inline fn vec3_mul(a: Vec3, b: Element) Vec3 {
            return @as(Vec3V, a) * @as(Vec3V, @splat(b));
        }

        inline fn vec3_ne(a: Vec3, b: Vec3) bool {
            return a[0] != b[0] or a[1] != b[1] or a[2] != b[2];
        }

        inline fn vec3_neg(a: Vec3) Vec3 {
            return -@as(Vec3V, a);
        }

        inline fn vec3_normalize(a: Vec3) Vec3 {
            return @as(Vec3V, a) / @as(Vec3V, @splat(@sqrt(@reduce(.Add, @as(Vec3V, a) * @as(Vec3V, a)))));
        }

        inline fn vec3_rem(a: Vec3, b: Element) Vec3 {
            return @rem(@as(Vec3V, a), @as(Vec3V, @splat(b)));
        }

        inline fn vec3_sub(a: Vec3, b: Vec3) Vec3 {
            return @as(Vec3V, a) - @as(Vec3V, b);
        }

        inline fn vec4_add(a: Vec4, b: Vec4) Vec4 {
            return a + b;
        }

        inline fn vec4_approx_eq(a: Vec4, b: Vec4, c: Element) bool {
            const diff = a - b;
            return @reduce(.Min, @as(Vec4, @splat(c)) - @abs(diff)) >= 0;
        }

        inline fn vec4_div(a: Vec4, b: Element) Vec4 {
            return a / @as(Vec4, @splat(b));
        }

        inline fn vec4_dot(a: Vec4, b: Vec4) Element {
            return @reduce(.Add, a * b);
        }

        inline fn vec4_eq(a: Vec4, b: Vec4) bool {
            return a[0] == b[0] and a[1] == b[1] and a[2] == b[2] and a[3] == b[3];
        }

        inline fn vec4_len(a: Vec4) Element {
            return @sqrt(@reduce(.Add, a * a));
        }

        inline fn vec4_len_squared(a: Vec4) Element {
            return @reduce(.Add, a * a);
        }

        inline fn vec4_mad(a: Vec4, b: Element, c: Vec4) Vec4 {
            return @mulAdd(Vec4, a, @splat(b), c);
        }

        inline fn vec4_max(a: Vec4, b: Vec4) Vec4 {
            return @max(@as(Vec4V, a), @as(Vec4V, b));
        }

        inline fn vec4_min(a: Vec4, b: Vec4) Vec4 {
            return @min(@as(Vec4V, a), @as(Vec4V, b));
        }

        inline fn vec4_mul(a: Vec4, b: Element) Vec4 {
            return a * @as(Vec4, @splat(b));
        }

        inline fn vec4_ne(a: Vec4, b: Vec4) bool {
            return a[0] != b[0] or a[1] != b[1] or a[2] != b[2] or a[3] != b[3];
        }

        inline fn vec4_neg(a: Vec4) Vec4 {
            return -a;
        }

        inline fn vec4_normalize(a: Vec4) Vec4 {
            return a / @as(Vec4, @splat(@sqrt(@reduce(.Add, a * a))));
        }

        inline fn vec4_rem(a: Vec4, b: Element) Vec4 {
            return @rem(a, @as(Vec4, @splat(b)));
        }

        inline fn vec4_sub(a: Vec4, b: Vec4) Vec4 {
            return a - b;
        }
    };
}

/// Built-in implementation for floating point numbers. Very naive implementations and should only be used with testing.
pub fn builtinImplementationFloat(comptime Element: type) Implementation(Element) {
    const impl = BuiltinImplementationFloat(Element);
    return .{
        .elem_abs = impl.elem_abs,
        .elem_add = impl.elem_add,
        .elem_approx_eq = impl.elem_approx_eq,
        .elem_ceil = impl.elem_ceil,
        .elem_cos = impl.elem_cos,
        .elem_cmpxchg_strong = impl.elem_cmpxchg_strong,
        .elem_cmpxchg_weak = impl.elem_cmpxchg_weak,
        .elem_div = impl.elem_div,
        .elem_eq = impl.elem_eq,
        .elem_exp = impl.elem_exp,
        .elem_exp2 = impl.elem_exp2,
        .elem_floor = impl.elem_floor,
        .elem_from_float = impl.elem_from_float,
        .elem_from_int = impl.elem_from_int,
        .elem_ge = impl.elem_ge,
        .elem_gt = impl.elem_gt,
        .elem_le = impl.elem_le,
        .elem_log = impl.elem_log,
        .elem_log2 = impl.elem_log2,
        .elem_log10 = impl.elem_log10,
        .elem_lt = impl.elem_lt,
        .elem_mad = impl.elem_mad,
        .elem_max = impl.elem_max,
        .elem_min = impl.elem_min,
        .elem_mod = impl.elem_mod,
        .elem_mul = impl.elem_mul,
        .elem_ne = impl.elem_ne,
        .elem_neg = impl.elem_neg,
        .elem_pow = impl.elem_pow,
        .elem_rem = impl.elem_rem,
        .elem_round = impl.elem_round,
        .elem_sin = impl.elem_sin,
        .elem_sqrt = impl.elem_sqrt,
        .elem_sub = impl.elem_sub,
        .elem_tan = impl.elem_tan,
        .elem_trunc = impl.elem_trunc,

        .vec2_add = impl.vec2_add,
        .vec2_approx_eq = impl.vec2_approx_eq,
        .vec2_div = impl.vec2_div,
        .vec2_dot = impl.vec2_dot,
        .vec2_eq = impl.vec2_eq,
        .vec2_len = impl.vec2_len,
        .vec2_len_squared = impl.vec2_len_squared,
        .vec2_mad = impl.vec2_mad,
        .vec2_max = impl.vec2_max,
        .vec2_min = impl.vec2_min,
        .vec2_mul = impl.vec2_mul,
        .vec2_ne = impl.vec2_ne,
        .vec2_neg = impl.vec2_neg,
        .vec2_normalize = impl.vec2_normalize,
        .vec2_rem = impl.vec2_rem,
        .vec2_sub = impl.vec2_sub,

        .vec3_add = impl.vec3_add,
        .vec3_approx_eq = impl.vec3_approx_eq,
        .vec3_cross = impl.vec3_cross,
        .vec3_div = impl.vec3_div,
        .vec3_dot = impl.vec3_dot,
        .vec3_eq = impl.vec3_eq,
        .vec3_len = impl.vec3_len,
        .vec3_len_squared = impl.vec3_len_squared,
        .vec3_mad = impl.vec3_mad,
        .vec3_max = impl.vec3_max,
        .vec3_min = impl.vec3_min,
        .vec3_mul = impl.vec3_mul,
        .vec3_ne = impl.vec3_ne,
        .vec3_neg = impl.vec3_neg,
        .vec3_normalize = impl.vec3_normalize,
        .vec3_rem = impl.vec3_rem,
        .vec3_sub = impl.vec3_sub,

        .vec4_add = impl.vec4_add,
        .vec4_approx_eq = impl.vec4_approx_eq,
        .vec4_div = impl.vec4_div,
        .vec4_dot = impl.vec4_dot,
        .vec4_eq = impl.vec4_eq,
        .vec4_len = impl.vec4_len,
        .vec4_len_squared = impl.vec4_len_squared,
        .vec4_mad = impl.vec4_mad,
        .vec4_max = impl.vec4_max,
        .vec4_min = impl.vec4_min,
        .vec4_mul = impl.vec4_mul,
        .vec4_ne = impl.vec4_ne,
        .vec4_neg = impl.vec4_neg,
        .vec4_normalize = impl.vec4_normalize,
        .vec4_rem = impl.vec4_rem,
        .vec4_sub = impl.vec4_sub,
    };
}

test "Element" {
    const impl = builtinImplementationFloat(f32);

    try std.testing.expect(comptime impl.elem_abs(-3.7) == 3.7);
    try std.testing.expect(comptime impl.elem_abs(3.7) == 3.7);

    try std.testing.expect(comptime impl.elem_add(-5.3, -4.8) == -10.1);
    try std.testing.expect(comptime impl.elem_add(-5.3, 4.8) == -0.5);
    try std.testing.expect(comptime impl.elem_add(5.3, 4.8) == 10.1);

    try std.testing.expect(comptime impl.elem_approx_eq(-5.3, -5, 0.30001));
    try std.testing.expect(comptime !impl.elem_approx_eq(-5.3, -5, 0.2));

    try std.testing.expect(comptime impl.elem_ceil(3) == 3);
    try std.testing.expect(comptime impl.elem_ceil(3.2) == 4);
    try std.testing.expect(comptime impl.elem_ceil(-3.2) == -3);

    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_cos(-5.3), @cos(-5.3), 0.001));
    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_cos(4.8), @cos(4.8), 0.001));

    // TODO: CMPEXCHANGE!!!

    try std.testing.expect(comptime impl.elem_div(-5.3, 0.1) == -53);
    try std.testing.expect(comptime impl.elem_div(4.8, 2) == 2.4);

    try std.testing.expect(comptime impl.elem_eq(-5.3, -5.3));
    try std.testing.expect(comptime !impl.elem_eq(4.8, -5.3));

    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_exp(-5.3), 0.005, 0.001));
    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_exp(4.8), 121.51, 0.001));

    // TODO: SOME!!!

    try std.testing.expect(comptime impl.elem_round(-5.3) == -5);
    try std.testing.expect(comptime impl.elem_round(-5.5) == -6);
    try std.testing.expect(comptime impl.elem_round(4.5) == 5);
    try std.testing.expect(comptime impl.elem_round(4.8) == 5);

    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_sin(-5.3), @sin(-5.3), 0.001));
    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_sin(4.8), @sin(4.8), 0.001));

    try std.testing.expect(comptime impl.elem_sqrt(4) == 2);

    try std.testing.expect(comptime impl.elem_sub(-5.3, -4.8) == -0.5);
    try std.testing.expect(comptime impl.elem_sub(-5.3, 4.8) == -10.1);
    try std.testing.expect(comptime impl.elem_sub(5.3, 4.8) == 0.5);

    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_tan(-5.3), @tan(-5.3), 0.001));
    try std.testing.expect(comptime impl.elem_approx_eq(impl.elem_tan(4.8), @tan(4.8), 0.001));

    try std.testing.expect(comptime impl.elem_trunc(-5.3) == -5);
    try std.testing.expect(comptime impl.elem_trunc(4.8) == 4);
}
