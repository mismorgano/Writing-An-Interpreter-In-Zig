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
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "five" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .INTEGER, .expected_literal = "5" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "ten" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "add" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .FUNCTION, .expected_literal = "fn" },
        .{ .expected_type = .LEFT_PAREN, .expected_literal = "(" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "x" },
        .{ .expected_type = .COMMA, .expected_literal = "," },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "y" },
        .{ .expected_type = .RIGHT_PAREN, .expected_literal = ")" },
        .{ .expected_type = .LEFT_BRACE, .expected_literal = "{" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "x" },
        .{ .expected_type = .PLUS, .expected_literal = "+" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "y" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .RIGHT_BRACE, .expected_literal = "}" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "result" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "add" },
        .{ .expected_type = .LEFT_PAREN, .expected_literal = "(" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "five" },
        .{ .expected_type = .COMMA, .expected_literal = "," },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "ten" },
        .{ .expected_type = .RIGHT_PAREN, .expected_literal = ")" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .BANG, .expected_literal = "!" },
        .{ .expected_type = .MINUS, .expected_literal = "-" },
        .{ .expected_type = .SLASH, .expected_literal = "/" },
        .{ .expected_type = .ASTERISK, .expected_literal = "*" },
        .{ .expected_type = .INTEGER, .expected_literal = "5" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .INTEGER, .expected_literal = "5" },
        .{ .expected_type = .LESS, .expected_literal = "<" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .GREATER, .expected_literal = ">" },
        .{ .expected_type = .INTEGER, .expected_literal = "5" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .IF, .expected_literal = "if" },
        .{ .expected_type = .LEFT_PAREN, .expected_literal = "(" },
        .{ .expected_type = .INTEGER, .expected_literal = "5" },
        .{ .expected_type = .LESS, .expected_literal = "<" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .RIGHT_PAREN, .expected_literal = ")" },
        .{ .expected_type = .LEFT_BRACE, .expected_literal = "{" },
        .{ .expected_type = .RETURN, .expected_literal = "return" },
        .{ .expected_type = .TRUE, .expected_literal = "true" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .RIGHT_BRACE, .expected_literal = "}" },
        .{ .expected_type = .ELSE, .expected_literal = "else" },
        .{ .expected_type = .LEFT_BRACE, .expected_literal = "{" },
        .{ .expected_type = .RETURN, .expected_literal = "return" },
        .{ .expected_type = .FALSE, .expected_literal = "false" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .RIGHT_BRACE, .expected_literal = "}" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .EQUAL, .expected_literal = "==" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .NOT_EQUAL, .expected_literal = "!=" },
        .{ .expected_type = .INTEGER, .expected_literal = "9" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .EOF, .expected_literal = "" },
    };

    var l = lexer.Lexer.init(input);
    // std.debug.print("{s}", .{input});
    for (tests) |tt| {
        const tok = l.nextToken();
        // std.debug.print("\n", .{});
        // std.debug.print("expected: {s}    real: {s} ", .{ tt.expected_literal, tok.Literal });
        // try std.testing.expectEqual(tt.expected_type, tok.Type);
        try std.testing.expectEqual(tt.expected_type, tok.type);

        try std.testing.expectEqualStrings(tt.expected_literal, tok.literal);
    }
}
