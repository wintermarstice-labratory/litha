const std = @import("std");

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

inline fn GeneratingFunctionShapeType(comptime F: type) type {
    // A generating function is a function that returns a scalar for
    // each coordinate of the tensor. For example, `f(x, y) = xy` is
    // such a function, filling every (x, y) coordinate with the
    // value `x * y`.
    //
    // A generating function must take N `usize` parameters for coordinates
    // and must return a scalar.

    const ArgsType = std.meta.ArgsTuple(F);
    const RetType = @typeInfo(F).Fn.return_type.?;

    // Check if the return type is a scalar (fXX, iXX, uXX)
    if (!comptime std.meta.trait.isNumber(RetType)) {
        @compileError("function is not a valid generating function - " ++ @typeName(RetType) ++ " is not a number type");
    }

    // Check if the all cooordinates are made of `usize`s.
    inline for (@typeInfo(ArgsType).Struct.fields, 0..) |T, I| {
        if (T.type != usize) {
            @compileError(std.fmt.comptimePrint("function is not a valid generating function - argument number {} is not an 'usize', it is '{s}'", .{ I, @typeName(T) }));
        }
    }

    return [@typeInfo(ArgsType).Struct.fields.len]usize;
}

inline fn GeneratingFunctionOutputStorageType(comptime F: type, comptime shape: anytype) type {
    // A shape is a N-tuple of usize's describing the shape of the resulting n-d array.
    // For example, the shape .{ 3, 3 } will require a 2D array, because there are
    // 2 dimensions specified. The generating function will be evaluated for each
    // cell coordinate of the array.
    //
    // For example; for a generating function that takes 2 usize's, and returns f32's at each
    // coordinate, for a shape of .{ 3, 3 }, ought to return a [3][3]f32, where each element
    // is the generating function value evaluated at corresponding coordinate.

    const ArgsType = std.meta.ArgsTuple(F);
    const RetType = @typeInfo(F).Fn.return_type.?;

    // Let's do some error checking - start by the shape.
    if (@TypeOf(shape) != ArgsType) {
        @compileError("shape type does not match generating function's argument tuple type - expected " ++ @typeName(ArgsType) ++ ", found " ++ @typeName(@TypeOf(shape)));
    }

    return _CreateNdArrayBackingTypeFromShape(RetType, shape);
}

inline fn generateNdArrayFromFunctionClosure(comptime Closure: type, comptime shape: anytype) GeneratingFunctionOutputStorageType(@TypeOf(Closure.at), shape) {
    const Backing = GeneratingFunctionOutputStorageType(@TypeOf(Closure.at), shape);

    var backing: Backing = undefined;
    _ = backing;

    // TODO: Somehow iterate as much as required as per shape. N for loops needed? (or should I flatten and use divmod chain?)
    @compileError("not implemented");
}

inline fn _CreateNdArrayBackingTypeFromShapeArrayAndLength(comptime S: type, comptime N: usize, comptime dimens: [N]usize) type {
    if (N == 0) {
        return S;
    } else {
        return [dimens[0]]_CreateNdArrayBackingTypeFromShapeArrayAndLength(S, N - 1, dimens[1..]);
    }
}

inline fn _CreateNdArrayBackingTypeFromShape(comptime S: type, comptime array: anytype) type {
    const N = @typeInfo(@TypeOf(array)).Array.len;
    const dimens = @as([N]usize, array);
    return _CreateNdArrayBackingTypeFromShapeArrayAndLength(S, N, dimens);
}

test "analyzeGeneratingFunction/fn(usize, usize) f32" {
    const Actual = GeneratingFunctionShapeType(fn (usize, usize) f32);
    const Expected = [2]usize;

    try std.testing.expectEqual(Expected, Actual);
}
