const std = @import("std");

/// An angle that is backed by an unsigned integer with wrap-around and can be made into degrees/radians of floating precision.
pub fn Angle(comptime Width: type) type {
    return struct {
        const Self = @This();
        /// Fixed-point number where the smallest possible value is 0 and the largest possible value is one unit away from 360 degrees.
        units: Width,

        /// Bitwidth of units.
        const unit_bitwidth = switch (@typeInfo(Width)) {
            .Int => |val| if (val.signedness == .unsigned) val.bits else @compileError("Angle may only be backed by unsigned integer type"),
            else => @compileError("Angle may only be backed by unsigned integer type"),
        };

        /// Total amount of degrees in a full rotation.
        const total_rotation_degrees = 360.0;
        /// Total amount of radians in a full rotation.
        const total_rotation_radians = 2.0 * std.math.pi;
        /// The value of the unit that represents a total rotation (1 plus the max value of Width).
        const total_rotation_units = std.math.pow(usize, 2, unit_bitwidth);

        /// How many units make up a single degree.
        const unit_per_deg: comptime_float = @as(comptime_float, @floatFromInt(total_rotation_units)) / total_rotation_degrees;
        /// How many units make up a single radian.
        const unit_per_rad = @as(comptime_float, @floatFromInt(total_rotation_units)) / total_rotation_radians;

        /// 0 degree angle.
        pub const deg_0 = Angle(Width){ .units = 0 }; // 0/8
        /// 45 degree angle.
        pub const deg_45 = Angle(Width){ .units = @intCast(total_rotation_units / 8) }; // 1/8
        /// 90 degree angle.
        pub const deg_90 = Angle(Width){ .units = @intCast(total_rotation_units / 4) }; // 2/8
        /// 135 degree angle.
        pub const deg_135 = Angle(Width){ .units = @intCast(total_rotation_units / 8 * 3) }; // 3/8
        /// 180 degree angle.
        pub const deg_180 = Angle(Width){ .units = @intCast(total_rotation_units / 2) }; // 4/8
        /// 225 degree angle.
        pub const deg_225 = Angle(Width){ .units = @intCast(total_rotation_units / 8 * 5) }; // 5/8
        /// 270 degree angle.
        pub const deg_270 = Angle(Width){ .units = @intCast(total_rotation_units / 4 * 3) }; // 6/8
        /// 315 degree angle.
        pub const deg_315 = Angle(Width){ .units = @intCast(total_rotation_units / 8 * 7) }; // 7/8

        /// 0 radians angle.
        pub const rad_0 = deg_0;
        /// π/4 radians angle.
        pub const rad_pi_over_4 = deg_45;
        /// π/2 radians angle.
        pub const rad_pi_over_2 = deg_90;
        /// 3π/4 radians angle.
        pub const rad_3_pi_over_4 = deg_135;
        /// π radians angle.
        pub const rad_pi = deg_180;
        /// 5π/4 radians angle.
        pub const rad_5_pi_over_4 = deg_225;
        /// 3π/2 radians angle.
        pub const rad_3_pi_over_2 = deg_270;
        /// 7π/4 radians angle.
        pub const rad_7_pi_over_4 = deg_315;

        /// Ensure a type is only a floating point type.
        fn ensureFloat(comptime Type: type) void {
            switch (@typeInfo(Type)) {
                .Float, .ComptimeFloat => {},
                else => @compileError("Precision may only be a floating point type"),
            }
        }

        /// Create an angle from floating-point degrees value.
        pub fn fromDeg(val: anytype) Self {
            ensureFloat(@TypeOf(val));
            return .{ .units = @intFromFloat(@mod(val, total_rotation_degrees) * unit_per_deg) };
        }

        /// Convert an angle to floating-point degrees with a given floating-point precision. This will be in range [0, 360).
        pub fn toDeg(self: Self, comptime Precision: type) Precision {
            ensureFloat(Precision);
            return @as(Precision, @floatFromInt(self.units)) / unit_per_deg;
        }

        /// Convert an angle to negative floating-point degrees with a given floating-point precision. This will be in range [-360, 0).
        pub fn toDegNeg(self: Self, comptime Precision: type) Precision {
            return self.toDeg(Precision) - total_rotation_degrees;
        }

        /// Create an angle from floating-point radians value.
        pub fn fromRad(val: anytype) Self {
            ensureFloat(@TypeOf(val));
            return .{ .units = @intFromFloat(@mod(val, total_rotation_radians) * unit_per_rad) };
        }

        /// Convert an angle to floating-point radians with a given floating-point precision. This will be in the range [0, 2π).
        pub fn toRad(self: Self, comptime Precision: type) Precision {
            ensureFloat(Precision);
            return @as(Precision, @floatFromInt(self.units)) / unit_per_rad;
        }

        /// Convert an angle to negative floating-point degrees with a given floating-point precision. This will be in the range [-2π, 0)
        pub fn toRadNeg(self: Self, comptime Precision: type) Precision {
            return self.toDeg(Precision) - total_rotation_radians;
        }

        /// Add two binary angles together.
        pub fn add(self: Self, other: Self) Self {
            return .{ .units = self.units +% other.units };
        }

        /// Set this binary angle to the sum of this with another angle.
        pub fn addEq(self: *Self, other: Self) void {
            self.units +%= other.units;
        }

        /// Subtract a binary angle from this angle.
        pub fn sub(self: Self, other: Self) Self {
            return .{ .units = self.units -% other.units };
        }

        /// Set this binary angle to the value of this angle minus the other angle.
        pub fn subEq(self: *Self, other: Self) void {
            self.units -%= other.units;
        }

        /// Multiply this binary angle with a floating-point scale.
        pub fn mul(self: Self, comptime Precision: type, scale: Precision) Self {
            ensureFloat(Precision);
            return .{ .units = @intFromFloat(@mod(@as(Precision, @floatFromInt(self.units)) * scale, @as(Precision, @floatFromInt(total_rotation_units)))) };
        }

        /// If this binary angle equals another one.
        pub fn eq(self: Self, other: Self) bool {
            return self.units == other.units;
        }

        /// Check if this is close enough to another angle (min(|this - other|, |other - this|) <= max_angle_diff_between_angles).
        pub fn eqApprox(self: Self, other: Self, max_angle_diff_between_angles: Self) bool {
            const diff = @min(@abs(self.units -% other.units), @abs(other.units -% self.units));
            return diff <= max_angle_diff_between_angles.units;
        }

        /// If this binary angle is less than another one.
        pub fn lt(self: Self, other: Self) bool {
            return self.units < other.units;
        }

        /// If this binary angle is less than or equal to another one.
        pub fn le(self: Self, other: Self) bool {
            return self.units <= other.units;
        }

        /// If this binary angle is greater than another one.
        pub fn gt(self: Self, other: Self) bool {
            return self.units > other.units;
        }

        /// If this binary angle is greater than or equal to another one.
        pub fn ge(self: Self, other: Self) bool {
            return self.units >= other.units;
        }

        /// Lookup table type that supports 2^bit_precision number of entries for 1/4 of a cos/sin wave. ResultPrecision is a floating-point type of each LUT entry.
        pub fn LUT(comptime bit_precision: usize, comptime ResultPrecision: type) type {
            return [std.math.pow(usize, 2, bit_precision)]ResultPrecision;
        }

        /// Create a lookup table for fast cos/sin.
        /// The 2^bit_precision reflects how many entries for the LUT exist, and the ResultPrecision is a floating-point type of each LUT entry.
        /// Note that only a fourth of the range of the angle is used.
        pub fn createLUT(comptime bit_precision: usize, comptime ResultPrecision: type) LUT(bit_precision, ResultPrecision) {
            ensureFloat(ResultPrecision);
            if (bit_precision + 2 > unit_bitwidth)
                @compileError("Too precise LUT for internal binary angle representation");
            var ret: LUT(bit_precision, ResultPrecision) = undefined;
            for (0..ret.len - 1) |index| {

                // Upper 2 bits are not important since only 1/4 of the wave is needed to be present.
                // So for a u16 with 3 bits of precision, we would want 0, 0x800, 0x1000, ..., 0x3800.
                // This means you shift left 16-2-3 = 11.
                ret[index] = @cos((Self{ .units = index << (unit_bitwidth - 2 - bit_precision) }).toRad(ResultPrecision));
            }
            ret[ret.len - 1] = 0; // Special case that cos(90deg) = 0.
            return ret;
        }

        /// Get the cosine of the binary angle. Only use this with proper LUTs.
        pub fn cos(self: Self, lut: anytype) @typeInfo(@TypeOf(lut)).Array.child {

            // Constant used to represent upper two bits.
            const part_bits: Width = 0b11 << (unit_bitwidth - 2);

            // Figure out which part of the cosine wave cycle we are on [0, 90), [90, 180), [180, 270), or [270, 360).
            const part: u2 = @intCast((part_bits & self.units) >> (unit_bitwidth - 2));

            // How many bits are used per LUT index.
            const bit_precision = std.math.log2(@typeInfo(@TypeOf(lut)).Array.len);

            // Calculate index into LUT. Remove the top 2 bits, and shift right until bit_precision bits is all that is left.
            // Since top 2 bits are out of the picture, treat a say u16 as a u14. If bit_precision is 3 then we remove 11 of the least-significant digits. 16-2-3 = 11.
            const ind = (self.units & (~part_bits)) >> (unit_bitwidth - 2 - bit_precision);

            // Calculate cosine.
            return switch (part) {
                0 => lut[ind],
                1 => -lut[lut.len - ind - 1],
                2 => -lut[ind],
                3 => lut[lut.len - ind - 1],
            };
        }

        /// Get the sine of the binary angle. Only use this with proper LUTs.
        pub fn sin(self: Self, lut: anytype) @typeInfo(@TypeOf(lut)).Array.child {
            return self.sub(deg_90).cos(lut);
        }

        /// Interpolate the angle with another one.
        pub fn lerp(self: Self, other: Self, alpha: anytype) Self {
            ensureFloat(@TypeOf(alpha));
            return self.add(.{ .units = @as(
                Width,
                @intFromFloat(
                    @mod(alpha * @as(@TypeOf(alpha), @floatFromInt(other.sub(self))), total_rotation_units),
                ),
            ) });
        }
    };
}

test "Angle Constants" {
    const A = Angle(u32);

    try std.testing.expect(A.deg_0.toDeg(f32) == 0);
    try std.testing.expect(A.deg_45.toDeg(f32) == 45);
    try std.testing.expect(A.deg_90.toDeg(f32) == 90);
    try std.testing.expect(A.deg_135.toDeg(f32) == 135);
    try std.testing.expect(A.deg_180.toDeg(f32) == 180);
    try std.testing.expect(A.deg_225.toDeg(f32) == 225);
    try std.testing.expect(A.deg_270.toDeg(f32) == 270);
    try std.testing.expect(A.deg_315.toDeg(f32) == 315);

    try std.testing.expect(A.deg_0.toDegNeg(f32) == -360);
    try std.testing.expect(A.deg_45.toDegNeg(f32) == -315);
    try std.testing.expect(A.deg_90.toDegNeg(f32) == -270);
    try std.testing.expect(A.deg_135.toDegNeg(f32) == -225);
    try std.testing.expect(A.deg_180.toDegNeg(f32) == -180);
    try std.testing.expect(A.deg_225.toDegNeg(f32) == -135);
    try std.testing.expect(A.deg_270.toDegNeg(f32) == -90);
    try std.testing.expect(A.deg_315.toDegNeg(f32) == -45);
}

test "Angle Math" {
    const A = Angle(u32);

    const h: u32 = 5;
    try std.testing.expect(A.fromDeg(@as(f32, @floatFromInt(h))).toDeg(f32) == 5);
    try std.testing.expect(A.fromDeg(370.0).toDegNeg(f32) == -350);
    try std.testing.expect(comptime A.deg_45.add(A.deg_270).toDeg(comptime_float) == 315);
    try std.testing.expect(comptime A.deg_45.mul(comptime_float, 3.0).eq(A.deg_135));
}

test "Comparisons" {
    const A = Angle(u32);

    try std.testing.expect(A.deg_135.eq(A.rad_3_pi_over_4));
    try std.testing.expect(!A.deg_315.eq(A.rad_3_pi_over_4));

    try std.testing.expect(A.deg_135.lt(A.deg_225));
    try std.testing.expect(!A.deg_135.lt(A.deg_135));

    try std.testing.expect(!A.deg_90.eqApprox(A.deg_270, A.deg_45));
    try std.testing.expect(A.deg_90.eqApprox(A.deg_135, A.deg_90));

    try std.testing.expect(A.deg_135.eqApprox(A.deg_90, A.deg_90));
    try std.testing.expect(A.deg_45.eqApprox(A.deg_315, A.deg_90));
    try std.testing.expect(A.deg_315.eqApprox(A.deg_45, A.deg_90));
    try std.testing.expect(!A.deg_315.eqApprox(A.deg_45, A.deg_45));

    try std.testing.expect(A.deg_135.le(A.deg_225));
    try std.testing.expect(A.deg_135.le(A.deg_135));

    try std.testing.expect(A.deg_225.gt(A.deg_135));
    try std.testing.expect(!A.deg_135.gt(A.deg_135));

    try std.testing.expect(A.deg_225.ge(A.deg_135));
    try std.testing.expect(A.deg_135.ge(A.deg_135));
}

// test "LUT" {
//     @setEvalBranchQuota(20000);
//     const A = Angle(u32);
//     const lut = comptime A.createLUT(12, f32);
//     const angle = 140.0;
//     std.debug.print("Angle: {d}, Cos: {d}, Sin: {d}\n", .{ angle, A.fromDeg(angle).cos(lut), A.fromDeg(angle).sin(lut) });
// }
