const std = @import("std");
const Allocator = std.mem.Allocator;
const string = []const u8;

pub const ErrorReporter = struct {
    allocator: Allocator,
    reader: *std.io.Reader,
    writer: *std.io.Writer,
    hadError: bool = false,

    pub fn init(allocator: Allocator, in: *std.Io.Reader, out: *std.Io.Writer) ErrorReporter {
        return .{
            .allocator = allocator,
            .reader = in,
            .writer = out,
        };
    }

    pub fn err(self: *ErrorReporter, line: u64, message: string) !void {
        try self.report(line, "", message);
    }

    pub fn report(self: *ErrorReporter, line: u64, where: string, message: string) !void {
        self.hadError = true;
        try self.writer.print("[line {d} ] Error {s}: {s} \n", .{ line, where, message });
    }
};
