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

    return [@typeInfo(ArgsType).Struct.fields.len]RetType;
}

inline fn analyzeGeneratingFunction(comptime func: anytype) void {
    // A generating function is a function that returns a scalar for
    // each coordinate of the tensor. For example, `f(x, y) = xy` is
    // such a function, filling every (x, y) coordinate with the
    // value `x * y`.
    //
    // A generating function must take N `usize` parameters for coordinates
    // and must return a scalar.

    const FunType = @TypeOf(func);
    const ArgsType = std.meta.ArgsTuple(FunType);
    const ReturnType = @typeInfo(FunType).Fn.return_type.?;

    // Check if the return type is a scalar (fXX, iXX, uXX)
    if (!comptime std.meta.trait.isNumber(ReturnType)) {
        @compileError("function is not a valid generating function - " ++ @typeName(ReturnType) ++ " is not a number type");
    }

    // Check if the all cooordinates are made of `usize`s.
    inline for (@typeInfo(ArgsType).Struct.fields, 0..) |T, I| {
        if (T.type != usize) {
            @compileError(std.fmt.comptimePrint("function is not a valid generating function - argument number {} is not an 'usize', it is '{s}'", .{ I, @typeName(T) }));
        }
    }
}

test "analyzeGeneratingFunction/fn(usize, usize) f32" {
    const Closure = struct {
        pub fn at(i: usize, j: usize) f32 {
            return @as(f32, i) * @as(f32, j);
        }
    };

    analyzeGeneratingFunction(Closure.at);
}
