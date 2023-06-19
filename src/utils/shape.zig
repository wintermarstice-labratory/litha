const std = @import("std");

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

/// Gets the number of dimensions in the given array type.
/// For example, for an array type `[10][20]u8`, the number of dimensions is 2.
/// Returns the count of dimensions in the array type `T`.
inline fn countNumberOfDimensionsOfArrayType(comptime T: type) usize {
    return switch (@typeInfo(T)) {
        // If the type is an array, recursively count the number of dimensions in the child array type.
        .Array => |array| 1 + countNumberOfDimensionsOfArrayType(array.child),

        // If the type is not an array, return 0 to indicate that there are no more dimensions.
        else => 0,
    };
}

/// Gets the shape of the given array type.
/// The shape represents the size of each dimension in the array type.
/// For example, for an array type `[3][4]u8`, the shape would be `[3, 4]`.
/// Returns the shape of the array type `T`.
inline fn getShapeOfArrayType(comptime T: type) ShapeType(T) {
    return switch (@typeInfo(T)) {
        // If the type is an array, concatenate the length of the current dimension
        // with the shape of the child array type.
        .Array => |array| [1]usize{array.len} ++ getShapeOfArrayType(array.child),
        // If the type is a scalar type, return an empty shape with zero dimensions.
        .Int, .Float, .ComptimeInt, .ComptimeFloat => [0]usize{},
        // If the type is neither an array nor a scalar type, it is unreachable.
        else => unreachable,
    };
}

/// Gets the shape of the given array.
/// The shape represents the size of each dimension in the array.
/// For example, for an array `arr: [3][4]u8`, the shape would be `[3, 4]`.
/// Returns the shape of the array.
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
