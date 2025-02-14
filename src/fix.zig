const std = @import("std");

/// Make a fixed point number that has a scale of a power of 2.
/// * `whole_bits` - How many bits to use for the whole portion of the number.
/// * `fraction_bits` - How many fractional bits to use for the fractional portion of the number.
/// * `signed` - If the integer is signed or unsigned.
pub fn Fix2(whole_bits: comptime_int, fraction_bits: comptime_int, comptime signed: bool) type {
    return Fix(whole_bits + fraction_bits, @exp2(fraction_bits), signed);
}

/// Fixed point number implementation.
/// * `bits` - How many bits to use for the underlying integer.
/// * `scaling` - What to multiply one unit by to get the number "1".
/// * `signed` - If the integer is signed or unsigned.
pub fn Fix(bits: comptime_int, scaling: comptime_int, comptime signed: bool) type {
    return struct {
        pub const bit_width = bits;
        pub const scaling_factor = scaling;
        pub const is_signed = signed;
        const Self = @This();
        const BackingInt = @Type(.{ .Int = .{ .Signedness = if (signed) .signed else .unsigned, .bits = bits } });
        comptime {
            if (scaling <= 0) {
                @compileError("Must have a positive scaling factor");
            }
        }
        val: BackingInt,

        /// Return the absolute value of the number.
        pub inline fn abs(self: Self) Self {
            if (signed)
                return .{ .val = @abs(self.val) };
            return self;
        }

        /// Add two fixed point numbers.
        pub inline fn add(self: Self, other: Self) Self {
            return .{ .val = self.val + other.val };
        }

        /// Wrapping addition with two fixed point numbers.
        pub inline fn addWrap(self: Self, other: Self) Self {
            return .{ .val = self.val +% other.val };
        }

        /// Saturating addition with two fixed point numbers.
        pub inline fn addSat(self: Self, other: Self) Self {
            return .{ .val = self.val +| other.val };
        }

        // TODO: APPROX EQ!

        /// Cast this fixed-point number to another fixed-point type.
        pub inline fn cast(self: Self, comptime Dest: type) Dest {
            _ = self;
            return .{}; // TODO!!!
        }

        // TODO: CEIL!

        // TODO: DIVISION!!!

        // TODO: DIV EXACT!
        // TODO: DIV FLOOR!
        // TODO: DIV TRUNC!

        /// If this is equal to another fixed-point number.
        pub inline fn eq(self: Self, other: Self) bool {
            return self.val == other.val;
        }

        /// Round down to the nearest whole number.
        // pub inline fn floor(self: Self) Self {
        //     return .{ .val = self.val / scaling * scaling };
        // }

        /// Create a fixed-point number from a float.
        pub inline fn fromFloat(val: anytype) Self {
            const float_type = @TypeOf(val).Float;
            return .{ .val = @intFromFloat(@as(float_type, @floatFromInt(scaling)) * val) };
        }

        /// If this value is greater than or equal to another number.
        pub inline fn ge(self: Self, other: Self) bool {
            return self.val >= other.val;
        }

        /// If this value is greater than another number.
        pub inline fn gt(self: Self, other: Self) bool {
            return self.val > other.val;
        }

        /// If this value is less than or equal to another number.
        pub inline fn le(self: Self, other: Self) bool {
            return self.val <= other.val;
        }

        /// If this value is less than another number.
        pub inline fn lt(self: Self, other: Self) bool {
            return self.val < other.val;
        }

        /// Get the max of two fixed point numbers.
        pub inline fn max(self: Self, other: Self) Self {
            return .{ .val = @max(self.val, other.val) };
        }

        /// Get the min of two fixed point numbers.
        pub inline fn min(self: Self, other: Self) Self {
            return .{ .val = @min(self.val, other.val) };
        }

        // TODO: MOD!!!

        // /// Multiply two fixed point numbers.
        // pub inline fn mul(self: Self, other: Self) Fix(0, self.scaling_factor * other.scaling_factor, self.is_signed) {
        //     const new_bitwidth = @max(self.bit_width, other.bit_width) * 2;
        //     return .{ .val = self.val * other.val };
        // }

        /// If this does not equal another fixed point number.
        pub inline fn ne(self: Self, other: Self) bool {
            return self.val != other.val;
        }

        /// Standard negation.
        pub inline fn neg(self: Self) Self {
            return .{ .val = -self.val };
        }

        /// Wrapping negation.
        pub inline fn negWrap(self: Self) Self {
            return .{ .val = -%self.val };
        }

        // TODO: REM!!!

        /// Subtract another fixed point number from this number.
        pub inline fn sub(self: Self, other: Self) Self {
            return .{ .val = self.val - other.val };
        }

        /// Wrapping subtraction with two fixed point numbers.
        pub inline fn subWrap(self: Self, other: Self) Self {
            return .{ .val = self.val -% other.val };
        }

        /// Saturating subtraction with two fixed point numbers.
        pub inline fn subSat(self: Self, other: Self) Self {
            return .{ .val = self.val -| other.val };
        }

        /// Convert the fixed point number to a float.
        pub inline fn toFloat(self: Self, comptime Size: type) Size {
            _ = @typeInfo(Size).Float;
            return @as(Size, @floatFromInt(self.val)) / @as(Size, @floatFromInt(scaling));
        }

        /// Convert the fixed point number to an int.
        pub inline fn toInt(self: Self, comptime Size: type) Size {
            _ = @typeInfo(Size).Int;
            return @as(Size, @intCast(@as(usize, @intCast(self.val)) / @as(usize, @intCast(scaling))));
        }

        // TODO: TRUNC!!!

    };
}

test "Fixed Point" {
    // _ = Fix(20, 12);
}
