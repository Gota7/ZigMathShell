pub const builtinImplementationFloat = @import("builtin.zig").builtinImplementationFloat;
pub const Implementation = @import("implementation.zig").Implementation;
const Vectors = @import("vec.zig").Vectors;

const std = @import("std");

/// Make a math library personalized to operate on the types you need.
pub fn specialize(comptime Element: type, comptime impl: Implementation(Element)) type {
    return struct {
        const vectors = Vectors(Element, impl);
        pub const Vec2 = vectors.Vec2;
        pub const Vec3 = vectors.Vec3;
        pub const vec3 = vectors.vec3;
    };
}

test {
    _ = @import("vec.zig"); // The refAllDecs function only works with public mods?
    std.testing.refAllDecls(@This());
}
