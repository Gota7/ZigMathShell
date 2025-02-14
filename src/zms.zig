const angle = @import("angle.zig");
pub const builtinImplementationFloat = @import("builtin.zig").builtinImplementationFloat;
pub const Implementation = @import("implementation.zig").Implementation;
const Matrices = @import("mat.zig").Matrices;
const Vectors = @import("vec.zig").Vectors;

const std = @import("std");

/// Math specialization information.
pub const Specialization = struct {
    element: type,
    impl: *const anyopaque,
    angle_detail: type,
    row_major: bool,
};

/// Make a math library personalized to operate on the types you need.
pub fn specialize(comptime specialization: Specialization) type {
    return struct {
        pub const Element = specialization.element;
        pub const Angle = angle.Angle(specialization.angle_detail);
        const vectors = Vectors(Element, @as(*const Implementation(Element), @ptrCast(specialization.impl)).*);
        pub const Vec2 = vectors.Vec2;
        pub const Vec3 = vectors.Vec3;
        pub const Vec4 = vectors.Vec4;
        pub const vec2 = vectors.vec2;
        pub const vec3 = vectors.vec3;
        pub const vec4 = vectors.vec4;
        const matrices = Matrices(Element, @as(*const Implementation(Element), @ptrCast(specialization.impl)).*, specialization.row_major);
        pub const Mat2 = matrices.Mat2;
    };
}

test {
    _ = @import("fix.zig");
    _ = @import("vec.zig"); // The refAllDecs function only works with public mods?
    std.testing.refAllDecls(@This());
    _ = Specialization{
        .element = f32,
        .impl = &builtinImplementationFloat(f32),
        .angle_detail = u32,
        .row_major = false,
    };
}
