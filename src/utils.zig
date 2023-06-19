const std = @import("std");

inline fn countNumberOfDimensionsOfArrayType(comptime T: type) usize {
    return switch (@typeInfo(T)) {
        .Array => |array| 1 + countNumberOfDimensionsOfArrayType(array.child),
        else => 0,
    };
}

/// Gets the array type to represent the **shape** of the given n-d array.
/// For example, a matrix would get [2]usize as matrix has 2 dimensions.
/// Returns [N]S where N is the dimension count and S is the scalar element
/// type of the n-d array type T.
inline fn ShapeType(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .Array => [countNumberOfDimensionsOfArrayType(T)]usize,
        .Int, .Float, .ComptimeInt, .ComptimeFloat => [0]usize,
        else => @compileError(std.fmt.comptimePrint("{s}: unsupported type", .{@typeName(T)})),
    };
}

inline fn getShapeOfArrayType(comptime T: type) ShapeType(T) {
    return switch (@typeInfo(T)) {
        .Array => |array| [1]usize{array.len} ++ getShapeOfArrayType(array.child),
        .Int, .Float, .ComptimeInt, .ComptimeFloat => [0]usize{},
        else => unreachable,
    };
}

inline fn getShapeOfArray(array: anytype) ShapeType(@TypeOf(array)) {
    return getShapeOfArrayType(@TypeOf(array));
}

test "getShapeOfArray/scalar" {
    const scalar = @as(f32, 0.0);
    const actual = getShapeOfArray(scalar);
    const expected = [0]usize{};

    try std.testing.expectEqual(expected, actual);
}

test "getShapeOfArray/1d array" {
    const array = [3]f32{ 1.0, 2.0, 3.0 };
    const actual = getShapeOfArray(array);
    const expected = [1]usize{3};

    try std.testing.expectEqual(expected, actual);
}

test "getShapeOfArray/2d array" {
    const matrix = [2][3]f32{
        [3]f32{ 1.0, 0.0, 1.0 },
        [3]f32{ 0.0, 1.0, 0.0 },
    };
    const actual = getShapeOfArray(matrix);
    const expected = [2]usize{ 2, 3 };

    try std.testing.expectEqualDeep(actual, expected);
}

pub fn Range(comptime T: type) type {
    return struct {
        start: T = @as(T, 0),
        stop: T,
        step: T = @as(T, 1),

        const Self = @This();

        pub inline fn iterator(self: Self) RangeIterator(T) {
            return RangeIterator(T){ .cursor = self.start, .step = self.step, .stop = self.stop };
        }
    };
}

pub fn RangeIterator(comptime T: type) type {
    return struct {
        cursor: T,
        step: T,
        stop: T,

        const Self = @This();

        pub fn next(self: *Self) ?T {
            if (self.cursor < self.stop) {
                defer self.cursor += self.step;
                return self.cursor;
            }

            return null;
        }
    };
}
