const std = @import("std");
const lexer = @import("../lexer/lexer.zig");
const token = @import("token");

const PROMPT = ">>";

pub fn Start(allocator: std.mem.Allocator, in: *std.Io.Reader, out: *std.Io.Writer) !void {
    // var stdin_buffer: [1024]u8 = undefined;
    // var stdin = std.fs.File.stdin();
    // var stdin_reader = stdin.reader(&stdin_buffer);
    // const stdin_ioreader = &stdin_reader.interface;

    try out.print("{s}", .{PROMPT});

    var allocating_writer = std.Io.Writer.Allocating.init(allocator);
    defer allocating_writer.deinit();

    while (in.streamDelimiter(&allocating_writer.writer, '\n')) |_| {
        const line = allocating_writer.written();
        try out.print("{s}\n", .{line});
        allocating_writer.clearRetainingCapacity();
        in.toss(1);
        try out.flush();
    } else |err| {
        try out.print("{any}\n", .{err});
    }
}

// pub fn start(reader: anytype, writer: anytype) !void {
//     // 1. Wrap the reader in a buffer for efficiency

//     var buf_reader = std.io.bufferedReader(reader);
//     var in = buf_reader.reader();

//     // 2. Define a fixed buffer for the input (e.g., 1KB)
//     var buf: [1024]u8 = undefined;

//     while (true) {
//         try writer.print("{s}", .{PROMPT});

//         // 3. This is the equivalent of scanner.Scan()
//         // It reads until '\n' or EOF.
//         // We use a slice to capture the actual data read into the buffer.
//         if (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
//             // Success! 'line' points into our 'buf'
//             try writer.print("You typed: {s}\n", .{line});
//         } else {
//             // This is the !scanned / EOF case
//             break;
//         }
//     }
// }
