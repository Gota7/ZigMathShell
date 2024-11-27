const Implementation = @import("implementation.zig").Implementation;

const builtin = @import("builtin.zig");
const std = @import("std");

pub fn Vectors(comptime Element: type, comptime impl: Implementation(Element)) type {
    return struct {
        // 2-dimensional vector data.
        pub const Vec2 = struct {
            data: @Vector(2, Element),

            /// The zero vector.
            pub const zero = splat(0);

            /// The one vector.
            pub const one = splat(1);

            /// Add this vector with another vector.
            pub inline fn add(self: Vec2, other: Vec2) Vec2 {
                return .{ .data = impl.vec2_add(self.data, other.data) };
            }

            /// If the vector is approximately equal to another one.
            pub inline fn approxEql(self: Vec2, other: Vec2, max_error_per_elem: Element) bool {
                return impl.vec2_approx_eql(self.data, other.data, max_error_per_elem);
            }

            /// Create a vector that is a direction and magnitude from this as a point to another point.
            pub inline fn createVecTo(self: Vec2, other: Vec2) Vec2 {
                return other.sub(self);
            }

            /// Divide this vector by an element.
            pub inline fn div(self: Vec2, other: Element) Vec2 {
                return .{ .data = impl.vec2_div(self.data, other) };
            }

            /// Dot this vector with another vector.
            pub inline fn dot(self: Vec2, other: Vec2) Element {
                return impl.vec2_dot(self.data, other.data);
            }

            /// If this vector is equal to another vector.
            pub inline fn eql(self: Vec2, other: Vec2) bool {
                return @reduce(.And, self.data == other.data);
            }

            /// Get the length of this vector (magnitude) and normalize this vector all in one go.
            pub inline fn getLenAndNormalizeSelf(self: *Vec2) Element {
                const length = self.len();
                self.* = self.normalize();
                return length;
            }

            /// Get the length of this vector (magnitude).
            pub inline fn len(self: Vec2) Element {
                return impl.vec2_len(self.data);
            }

            /// Get the squared length of this vector (equivalent to the dot product with itself).
            pub inline fn lenSquared(self: Vec2) Element {
                return impl.vec2_len_squared(self.data);
            }

            /// Multiply this vector with another vector, then add another vector after with one operation.
            pub inline fn mad(self: Vec2, other_mul: Element, other_add: Vec2) Vec2 {
                return .{ .data = impl.vec2_mad(self.data, other_mul, other_add.data) };
            }

            /// Multiply this vector by an element.
            pub inline fn mul(self: Vec2, other: Element) Vec2 {
                return .{ .data = impl.vec2_mul(self.data, other) };
            }

            /// Make this vector unit-length (magnitude of one).
            pub inline fn normalize(self: Vec2) Vec2 {
                return .{ .data = impl.vec2_normalize(self.data) };
            }

            /// Get a vector perpendicular to this one.
            pub inline fn perpendicularWithNewXNeg(self: Vec2) Vec2 {
                return .{ .data = [_]Element{ -self.data[1], self.data[0] } };
            }

            /// Get a vector perpendicular to this one.
            pub inline fn perpendicularWithNewYNeg(self: Vec2) Vec2 {
                return .{ .data = [_]Element{ self.data[1], -self.data[0] } };
            }

            /// Create a vector with all elements initialized to the same value.
            pub inline fn splat(val: Element) Vec2 {
                return .{ .data = @splat(val) };
            }

            /// Subtract from this vector with another vector.
            pub inline fn sub(self: Vec2, other: Vec2) Vec2 {
                return .{ .data = impl.vec2_sub(self.data, other.data) };
            }
        };

        // 3-dimensional vector data.
        pub const Vec3 = struct {
            data: @Vector(3, Element),

            /// The zero vector.
            pub const zero = splat(0);

            /// The one vector.
            pub const one = splat(1);

            /// Add this vector with another vector.
            pub inline fn add(self: Vec3, other: Vec3) Vec3 {
                return .{ .data = impl.vec3_add(self.data, other.data) };
            }

            /// If the vector is approximately equal to another one.
            pub inline fn approxEql(self: Vec3, other: Vec3, max_error_per_elem: Element) bool {
                return impl.vec3_approx_eql(self.data, other.data, max_error_per_elem);
            }

            /// Create a vector that is a direction and magnitude from this as a point to another point.
            pub inline fn createVecTo(self: Vec3, other: Vec3) Vec3 {
                return other.sub(self);
            }

            /// Cross this vector with another vector.
            pub inline fn cross(self: Vec3, other: Vec3) Vec3 {
                return .{ .data = impl.vec3_cross(self.data, other.data) };
            }

            /// Divide this vector by an element.
            pub inline fn div(self: Vec3, other: Element) Vec3 {
                return .{ .data = impl.vec3_div(self.data, other) };
            }

            /// Dot this vector with another vector.
            pub inline fn dot(self: Vec3, other: Vec3) Element {
                return impl.vec3_dot(self.data, other.data);
            }

            /// If this vector is equal to another vector.
            pub inline fn eql(self: Vec3, other: Vec3) bool {
                return @reduce(.And, self.data == other.data);
            }

            /// Get the length of this vector (magnitude) and normalize this vector all in one go.
            pub inline fn getLenAndNormalizeSelf(self: *Vec2) Element {
                const length = self.len();
                self.* = self.normalize();
                return length;
            }

            /// Get the length of this vector (magnitude).
            pub inline fn len(self: Vec3) Element {
                return impl.vec3_len(self.data);
            }

            /// Get the squared length of this vector (equivalent to the dot product with itself).
            pub inline fn lenSquared(self: Vec3) Element {
                return impl.vec3_len_squared(self.data);
            }

            /// Multiply this vector with another vector, then add another vector after with one operation.
            pub inline fn mad(self: Vec3, other_mul: Element, other_add: Vec3) Vec3 {
                return .{ .data = impl.vec3_mad(self.data, other_mul, other_add.data) };
            }

            /// Multiply this vector by an element.
            pub inline fn mul(self: Vec3, other: Element) Vec3 {
                return .{ .data = impl.vec3_mul(self.data, other) };
            }

            /// Make this vector unit-length (magnitude of one).
            pub inline fn normalize(self: Vec3) Vec3 {
                return .{ .data = impl.vec3_normalize(self.data) };
            }

            /// Create a vector with all elements initialized to the same value.
            pub inline fn splat(val: Element) Vec3 {
                return .{ .data = @splat(val) };
            }

            /// Subtract from this vector with another vector.
            pub inline fn sub(self: Vec3, other: Vec3) Vec3 {
                return .{ .data = impl.vec3_sub(self.data, other.data) };
            }
        };

        /// Create a new 2-dimensional vector.
        pub inline fn vec2(x: Element, y: Element) Vec3 {
            return .{ .data = .{ x, y } };
        }

        /// Create a new 3-dimensional vector.
        pub inline fn vec3(x: Element, y: Element, z: Element) Vec3 {
            return .{ .data = .{ x, y, z } };
        }
    };
}

test "Vec3" {
    const impl = builtin.builtinImplementationFloat(f32);
    const vecs = Vectors(f32, impl);

    // Constants.
    try std.testing.expect(comptime vecs.Vec3.zero
        .eql(vecs.vec3(0, 0, 0)));
    try std.testing.expect(comptime vecs.Vec3.one
        .eql(vecs.vec3(1, 1, 1)));

    // Basic add/sub.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .add(vecs.vec3(87, -54, -3))
        .eql(vecs.vec3(90, -59, -2)));
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .sub(vecs.vec3(87, -54, -3))
        .eql(vecs.vec3(-84, 49, 4)));

    // Distancing.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .createVecTo(vecs.vec3(87, -54, -3))
        .eql(vecs.vec3(84, -49, -4)));

    // Multiply divide.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .mul(3)
        .eql(vecs.vec3(9, -15, 3)));
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .mul(0)
        .eql(vecs.Vec3.zero));
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .div(2)
        .eql(vecs.vec3(1.5, -2.5, 0.5)));

    // Mad.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .mad(3, vecs.vec3(87, -54, -3))
        .eql(vecs.vec3(96, -69, 0)));

    // Length related.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .lenSquared() == 35);
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .len() == @sqrt(35.0));
    try std.testing.expect(comptime vecs.vec3(3, -5, 4)
        .normalize()
        .len() == 1);

    // Dot and cross.
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .dot(vecs.vec3(87, -54, -3)) == 3 * 87 + -5 * -54 + 1 * -3);
    try std.testing.expect(comptime vecs.vec3(3, -5, 1)
        .dot(vecs.Vec3.zero) == 0);
    try std.testing.expect(comptime vecs.vec3(1, 0, 0)
        .cross(vecs.vec3(0, 1, 0))
        .eql(vecs.vec3(0, 0, 1)));
    try std.testing.expect(comptime vecs.vec3(1, 2, 3)
        .cross(vecs.vec3(1, 5, 7))
        .eql(vecs.vec3(-1, -4, 3)));
}
