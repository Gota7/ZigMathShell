const Implementation = @import("implementation.zig").Implementation;

/// Built-in implementation for floating point numbers.
fn BuiltinImplementationFloat(comptime Element: type) type {
    return struct {
        const Vec2 = @Vector(2, Element);
        const Vec3 = @Vector(3, Element);

        inline fn vec2_add(a: Vec2, b: Vec2) Vec2 {
            return a + b;
        }

        inline fn vec2_approx_eql(a: Vec2, b: Vec2, c: Element) bool {
            const diff = a - b;
            return @reduce(.Min, @as(Vec2, @splat(c)) - @abs(diff)) >= 0;
        }

        inline fn vec2_div(a: Vec2, b: Element) Vec2 {
            return a / @as(Vec2, @splat(b));
        }

        inline fn vec2_dot(a: Vec2, b: Vec2) Element {
            return @reduce(.Add, a * b);
        }

        inline fn vec2_len(a: Vec2) Element {
            return @sqrt(@reduce(.Add, a * a));
        }

        inline fn vec2_len_squared(a: Vec2) Element {
            return @reduce(.Add, a * a);
        }

        inline fn vec2_mad(a: Vec2, b: Element, c: Vec2) Vec2 {
            return @mulAdd(Vec2, a, @splat(b), c);
        }

        inline fn vec2_mul(a: Vec2, b: Element) Vec2 {
            return a * @as(Vec2, @splat(b));
        }

        inline fn vec2_normalize(a: Vec2) Vec2 {
            return a / @as(Vec2, @splat(@sqrt(@reduce(.Add, a * a))));
        }

        inline fn vec2_sub(a: Vec2, b: Vec2) Vec2 {
            return a - b;
        }

        inline fn vec3_add(a: Vec3, b: Vec3) Vec3 {
            return a + b;
        }

        inline fn vec3_approx_eql(a: Vec3, b: Vec3, c: Element) bool {
            const diff = a - b;
            return @reduce(.Min, @as(Vec3, @splat(c)) - @abs(diff)) >= 0;
        }

        inline fn vec3_cross(a: Vec3, b: Vec3) Vec3 {
            // { a.y * b.z - a.z * b.y, -a.x * b.z + a.z * b.x, a.x * b.y - a.y * b.x }
            const pos_terms = @shuffle(Element, a, undefined, [_]u2{ 2, 0, 1 }) * b; // a.z * b.x, a.x * b.y, a.y * b.z
            const neg_terms = @shuffle(Element, a, undefined, [_]u2{ 1, 2, 0 }) * b; // a.y * b.x, a.z * b.y, a.x * b.z
            return @shuffle(Element, pos_terms, undefined, [_]u2{ 2, 0, 1 }) - @shuffle(Element, neg_terms, undefined, [_]u2{ 1, 2, 0 });
        }

        inline fn vec3_div(a: Vec3, b: Element) Vec3 {
            return a / @as(Vec3, @splat(b));
        }

        inline fn vec3_dot(a: Vec3, b: Vec3) Element {
            return @reduce(.Add, a * b);
        }

        inline fn vec3_len(a: Vec3) Element {
            return @sqrt(@reduce(.Add, a * a));
        }

        inline fn vec3_len_squared(a: Vec3) Element {
            return @reduce(.Add, a * a);
        }

        inline fn vec3_mad(a: Vec3, b: Element, c: Vec3) Vec3 {
            return @mulAdd(Vec3, a, @splat(b), c);
        }

        inline fn vec3_mul(a: Vec3, b: Element) Vec3 {
            return a * @as(Vec3, @splat(b));
        }

        inline fn vec3_normalize(a: Vec3) Vec3 {
            return a / @as(Vec3, @splat(@sqrt(@reduce(.Add, a * a))));
        }

        inline fn vec3_sub(a: Vec3, b: Vec3) Vec3 {
            return a - b;
        }
    };
}

/// Built-in implementation for floating point numbers. Very naive implementations and should only be used with testing.
pub fn builtinImplementationFloat(comptime Element: type) Implementation(Element) {
    const impl = BuiltinImplementationFloat(Element);
    return .{
        .vec2_add = impl.vec2_add,
        .vec2_approx_eql = impl.vec2_approx_eql,
        .vec2_div = impl.vec2_div,
        .vec2_dot = impl.vec2_dot,
        .vec2_len = impl.vec2_len,
        .vec2_len_squared = impl.vec2_len_squared,
        .vec2_mad = impl.vec2_mad,
        .vec2_mul = impl.vec2_mul,
        .vec2_normalize = impl.vec2_normalize,
        .vec2_sub = impl.vec2_sub,

        .vec3_add = impl.vec3_add,
        .vec3_approx_eql = impl.vec3_approx_eql,
        .vec3_cross = impl.vec3_cross,
        .vec3_div = impl.vec3_div,
        .vec3_dot = impl.vec3_dot,
        .vec3_len = impl.vec3_len,
        .vec3_len_squared = impl.vec3_len_squared,
        .vec3_mad = impl.vec3_mad,
        .vec3_mul = impl.vec3_mul,
        .vec3_normalize = impl.vec3_normalize,
        .vec3_sub = impl.vec3_sub,
    };
}
