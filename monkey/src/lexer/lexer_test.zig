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
        \\10<=11;
        \\11>=10;
        \\0.1 + 0.2 == 0.3
        \\// this is a line comment
        \\let hello = "world";
        \\let lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        \\Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante.
        \\Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna.  Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante.
        \\";
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
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .LESS_EQUAL, .expected_literal = "<=" },
        .{ .expected_type = .INTEGER, .expected_literal = "11" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .INTEGER, .expected_literal = "11" },
        .{ .expected_type = .GREATER_EQUAL, .expected_literal = ">=" },
        .{ .expected_type = .INTEGER, .expected_literal = "10" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .INTEGER, .expected_literal = "0.1" },
        .{ .expected_type = .PLUS, .expected_literal = "+" },
        .{ .expected_type = .INTEGER, .expected_literal = "0.2" },
        .{ .expected_type = .EQUAL, .expected_literal = "==" },
        .{ .expected_type = .INTEGER, .expected_literal = "0.3" },
        .{ .expected_type = .LINE_COMMENT, .expected_literal = " this is a line comment" },
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "hello" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .STRING, .expected_literal = "\"world\"" },
        .{ .expected_type = .SEMICOLON, .expected_literal = ";" },
        .{ .expected_type = .LET, .expected_literal = "let" },
        .{ .expected_type = .IDENTIFIER, .expected_literal = "lorem_ipsum" },
        .{ .expected_type = .ASSIGN, .expected_literal = "=" },
        .{ .expected_type = .STRING, .expected_literal = 
        \\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        \\Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante.
        \\Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna.  Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante.
        \\"
        },
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
