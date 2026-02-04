// const monkey = @import("monkey");
// const token = monkey.token;
// const lexer = monkey.lexer;
const token = @import("token");
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
        \\!-/*5;
        \\5 < 10 > 5;
        \\
        \\if (5 < 10) {
        \\  return true;
        \\} else {
        \\  return false;
        \\}
        \\10 == 10;
        \\10 != 9;
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
        .{ .expected_type = token.BANG, .expected_literal = "!" },
        .{ .expected_type = token.MINUS, .expected_literal = "-" },
        .{ .expected_type = token.SLASH, .expected_literal = "/" },
        .{ .expected_type = token.ASTERISK, .expected_literal = "*" },
        .{ .expected_type = token.INT, .expected_literal = "5" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.INT, .expected_literal = "5" },
        .{ .expected_type = token.LT, .expected_literal = "<" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.GT, .expected_literal = ">" },
        .{ .expected_type = token.INT, .expected_literal = "5" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.IF, .expected_literal = "if" },
        .{ .expected_type = token.LPAREN, .expected_literal = "(" },
        .{ .expected_type = token.INT, .expected_literal = "5" },
        .{ .expected_type = token.LT, .expected_literal = "<" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.RPAREN, .expected_literal = ")" },
        .{ .expected_type = token.LBRACE, .expected_literal = "{" },
        .{ .expected_type = token.RETURN, .expected_literal = "return" },
        .{ .expected_type = token.TRUE, .expected_literal = "true" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.RBRACE, .expected_literal = "}" },
        .{ .expected_type = token.ELSE, .expected_literal = "else" },
        .{ .expected_type = token.LBRACE, .expected_literal = "{" },
        .{ .expected_type = token.RETURN, .expected_literal = "return" },
        .{ .expected_type = token.FALSE, .expected_literal = "false" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.RBRACE, .expected_literal = "}" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.EQ, .expected_literal = "==" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.INT, .expected_literal = "10" },
        .{ .expected_type = token.NOT_EQ, .expected_literal = "!=" },
        .{ .expected_type = token.INT, .expected_literal = "9" },
        .{ .expected_type = token.SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = token.EOF, .expected_literal = "" },
    };

    var l = lexer.Lexer.init(input);
    // std.debug.print("{s}", .{input});
    for (tests) |tt| {
        const tok = l.nextToken();
        // std.debug.print("\n", .{});
        // std.debug.print("expected: {s}    real: {s} ", .{ tt.expected_literal, tok.Literal });
        // try std.testing.expectEqual(tt.expected_type, tok.Type);
        try std.testing.expectEqualStrings(tt.expected_type, tok.Type);

        try std.testing.expectEqualStrings(tt.expected_literal, tok.Literal);
    }
}
