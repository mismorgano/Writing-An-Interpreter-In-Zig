// const monkey = @import("monkey");
// const token = monkey.token;
// const lexer = monkey.lexer;
const token = @import("../token/token.zig");
const lexer = @import("lexer.zig");
const std = @import("std");
const expect = @import("std").testing.expect;

test "next token" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\
        \\let add = fn(x, y) {
        \\ x + y;
        \\}; 
        \\
        \\let result = add(five, ten);
    ;

    const ExpectedToken = struct { expected_type: token.TokenType, expected_literal: []const u8 };

    const tests = [_]ExpectedToken{
        .{ .expected_type = token.LET, .expected_literal = "let" },
        .{ .expected_type = token.IDENT, .expected_literal = "five" },
        .{ .expected_type = token.ASSIGN, .expected_literal = "=" },
        .{ .expected_type = token.INT, .expected_literal = "5" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.LET, .expected_literal = "let" },
        .{ .expected_type = token.IDENT, .expected_literal = "ten" },
        .{ .expected_type = token.ASSIGN, .expected_literal = "=" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.LET, .expected_literal = "let" },
        .{ .expected_type = token.IDENT, .expected_literal = "add" },
        .{ .expected_type = token.ASSIGN, .expected_literal = "=" },
        .{ .expected_type = token.FUNCTION, .expected_literal = "fn" },
        .{ .expected_type = token.LPAREN, .expected_literal = "(" },
        .{ .expected_type = token.IDENT, .expected_literal = "x" },
        .{ .expected_type = token.COMMA, .expected_literal = "," },
        .{ .expected_type = token.IDENT, .expected_literal = "y" },
        .{ .expected_type = token.RPAREN, .expected_literal = ")" },
        .{ .expected_type = token.LBRACE, .expected_literal = "{" },
        .{ .expected_type = token.IDENT, .expected_literal = "x" },
        .{ .expected_type = token.PLUS, .expected_literal = "+" },
        .{ .expected_type = token.IDENT, .expected_literal = "y" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.RBRACE, .expected_literal = "}" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.LET, .expected_literal = "let" },
        .{ .expected_type = token.IDENT, .expected_literal = "result" },
        .{ .expected_type = token.ASSIGN, .expected_literal = "=" },
        .{ .expected_type = token.IDENT, .expected_literal = "add" },
        .{ .expected_type = token.LPAREN, .expected_literal = "(" },
        .{ .expected_type = token.IDENT, .expected_literal = "five" },
        .{ .expected_type = token.COMMA, .expected_literal = "," },
        .{ .expected_type = token.IDENT, .expected_literal = "ten" },
        .{ .expected_type = token.RPAREN, .expected_literal = ")" },
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
