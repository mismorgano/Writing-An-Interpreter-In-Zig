const std = @import("std");
const lexer = @import("lexer");
const token = @import("token");

const PROMPT = ">>";

pub fn start(allocator: std.mem.Allocator, in: *std.Io.Reader, out: *std.Io.Writer) !void {
    var allocating_writer = std.Io.Writer.Allocating.init(allocator);
    defer allocating_writer.deinit();

    // "event loop"
    while (true) {
        try out.print("{s}", .{PROMPT});
        try out.flush();

        // read line
        if (in.streamDelimiter(&allocating_writer.writer, '\n')) |size| {
            if (size == 0) {
                break; // exit loop/exit app if there's not user input.
            }
            // getting line
            const line = allocating_writer.written();
            var lex = lexer.Lexer.init(line);
            var nextToken = lex.nextToken();

            //
            nextLine: switch (nextToken.Type) {
                .EOF => {},
                else => {
                    try out.print("{{Type: {s}, Literal: {s} }}\n", .{ @tagName(nextToken.Type), nextToken.Literal });
                    nextToken = lex.nextToken();
                    continue :nextLine nextToken.Type;
                },
            }

            allocating_writer.clearRetainingCapacity();
            in.toss(1);
            try out.flush();
        } else |err| {
            try out.print("{any}\n", .{err});
            try out.flush();
        }
    }
}
