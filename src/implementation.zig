/// Math function implementations to use.
pub fn Implementation(comptime Element: type) type {
    return struct {
        const Vec2 = @Vector(2, Element);
        const Vec3 = @Vector(3, Element);
        vec3_add: *const fn (a: Vec3, b: Vec3) callconv(.Inline) Vec3,
        vec3_approx_eql: *const fn (a: Vec3, b: Vec3, c: Element) callconv(.Inline) bool,
        vec3_cross: *const fn (a: Vec3, b: Vec3) callconv(.Inline) Vec3,
        vec3_div: *const fn (a: Vec3, b: Element) callconv(.Inline) Vec3,
        vec3_dot: *const fn (a: Vec3, b: Vec3) callconv(.Inline) Element,
        vec3_len: *const fn (a: Vec3) callconv(.Inline) Element,
        vec3_len_squared: *const fn (a: Vec3) callconv(.Inline) Element,
        vec3_mad: *const fn (a: Vec3, b: Element, c: Vec3) callconv(.Inline) Vec3,
        vec3_mul: *const fn (a: Vec3, b: Element) callconv(.Inline) Vec3,
        vec3_normalize: *const fn (a: Vec3) callconv(.Inline) Vec3,
        vec3_sub: *const fn (a: Vec3, b: Vec3) callconv(.Inline) Vec3,
    };
}
