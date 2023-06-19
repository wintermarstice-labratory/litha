//!
//! A simple XOR neural network example in Zig using Litha.
//!
//! Copyright (c) 2023 Buğra Kadirhan (wintermarstice)
//!
//! Look LICENSE file for licensing details.
//!

const std = @import("std");
const litha = @import("litha");

pub fn main() !void {
    const data = .{
        .{ .{ true, true }, .{false} },
        .{ .{ true, false }, .{true} },
        .{ .{ false, true }, .{true} },
        .{ .{ false, false }, .{false} },
    };

    // Use pure Zig CPU computation.
    var device = litha.getDevice(.{ .device_type = .Cpu, .implementation = .Native });
    defer device.deinit();

    // Define the model
    // TODO: Revise the architecture!
    var input = litha.layers.Input(.{ .shape = [2]f32 }).init();
    var linear_1 = litha.layers.Linear(.{ .units = 8 }).init(&input.output);
    var act_1 = litha.layers.Activation.Sigmoid.init(&linear_1.output);
    var linear_2 = litha.layers.Linear(.{ .units = 1 }).init(&act_1.output);
    var output = litha.layers.Activation.SoftMax.init(&linear_2.output);
    _ = output;

    // Define the training loop
    // TODO: To be continued.

    _ = data;
}
