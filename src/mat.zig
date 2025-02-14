const Implementation = @import("implementation.zig").Implementation;
const Vectors = @import("vec.zig").Vectors;

pub fn Matrices(comptime Element: type, comptime impl: Implementation(Element), row_major: bool) type {
    _ = row_major;
    return struct {
        const vectors = Vectors(Element, impl);
        const Vec2 = vectors.Vec2;
        const Vec3 = vectors.Vec3;
        const Vec4 = vectors.Vec4;
        /// 2x2 matrix.
        pub const Mat2 = struct {
            data: [2]Vec2,

            /// Add this matrix to another matrix.
            pub inline fn add(a: Mat2, b: Mat2) Mat2 {
                return .{
                    .data = .{
                        a.data[0].add(b.data[0]),
                        a.data[1].add(b.data[1]),
                    },
                };
            }

            /// Multiply this matrix by a scalar.
            pub inline fn scale(a: Mat2, b: Element) Mat2 {
                return .{
                    .data = .{
                        a.data[0].mul(b),
                        a.data[1].mul(b),
                    },
                };
            }

            /// Subtract from this matrix another matrix.
            pub inline fn sub(a: Mat2, b: Mat2) Mat2 {
                return .{
                    .data = .{
                        a.data[0].sub(b.data[0]),
                        a.data[1].sub(b.data[1]),
                    },
                };
            }
        };
    };
}
