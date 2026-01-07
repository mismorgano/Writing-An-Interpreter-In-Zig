// const monkey = @import("monkey");
// const token = monkey.token;
// const lexer = monkey.lexer;
const token = @import("../token/token.zig");
const lexer = @import("lexer.zig");
const std = @import("std");
const expect = @import("std").testing.expect;

test "next token" {
    const input = "=+(){},;";

    const ExpectedToken = struct { expected_type: token.TokenType, expected_literal: []const u8 };

    const tests = [_]ExpectedToken{
        .{ .expected_type = token.ASSIGN, .expected_literal = "=" },
        .{ .expected_type = token.PLUS, .expected_literal = "+" },
        .{ .expected_type = token.LPAREN, .expected_literal = "(" },
        .{ .expected_type = token.RPAREN, .expected_literal = ")" },
        .{ .expected_type = token.LBRACE, .expected_literal = "{" },
        .{ .expected_type = token.RBRACE, .expected_literal = "}" },
        .{ .expected_type = token.COMMA, .expected_literal = "," },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.EOF, .expected_literal = "" },
    };

    var l = lexer.Lexer.init(input);

    for (tests) |tt| {
        const tok = l.nextToken();

        std.debug.print("{s}\n", .{tt.expected_type});
        // try std.testing.expectEqual(tt.expected_type, tok.Type);
        try std.testing.expectEqualStrings(tt.expected_type, tok.Type);

        try std.testing.expectEqualStrings(tt.expected_literal, tok.Literal);
    }
}
