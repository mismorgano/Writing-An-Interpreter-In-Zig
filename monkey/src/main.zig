const std = @import("std");
const monkey = @import("monkey");
const repl = @import("repl/repl.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    try monkey.bufferedPrint();

    // allocator
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    // stdin
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;

    // stdout
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    // the cross-platform way to access args it's an iterator
    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.skip();

    // populate an arrayList from the args iterator
    var args: std.ArrayList([]const u8) = .empty;
    while (argsIterator.next()) |arg| {
        try args.append(allocator, arg);
    }

    // how the cli should be used based on number of arguments
    // more than one argument we specify its usage
    if (args.items.len > 1) {
        try stdout.print("Usage: monkey [script]", .{});
    } else if (args.items.len == 1) {
        //with one argument (a file) it runs the file
    } else {
        // with not arguments it's calling the repl
        try stdout.print("Try any commands \n", .{});
        // try stdout.flush();
        try repl.start(allocator, stdin, stdout);
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
