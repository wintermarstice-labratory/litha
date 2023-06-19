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
