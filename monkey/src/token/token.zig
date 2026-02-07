const std = @import("std");

// token types
pub const TokenType = enum {
    ILLEGAL,
    EOF,
    // Identifiers + literals
    IDENT,
    INT,
    // Operators
    ASSIGN, // =
    PLUS, // +
    MINUS, // -
    BANG, // !
    ASTERISK, // *
    SLASH, // /

    LT, // <
    GT, // >

    EQ, // ==
    NOT_EQ, // !=
    // Delimiters
    COMMA, // ,
    SEMICOLON, // ;

    LPAREN, // (
    RPAREN, // )
    LBRACE, // {
    RBRACE, // }
    // keywords
    FUNCTION, // function
    LET, // let
    TRUE, // true
    FALSE, // false
    IF, // if
    ELSE, // else
    RETURN, // return
};

pub const Token = struct {
    Type: TokenType,
    Literal: []const u8,
};

const keywords = std.StaticStringMap(TokenType).initComptime(.{
    .{ "fn", .FUNCTION },
    .{ "let", .LET },
    .{ "true", .TRUE },
    .{ "false", .FALSE },
    .{ "if", .IF },
    .{ "else", .ELSE },
    .{ "return", .RETURN },
});

pub fn lookupIdent(ident: []const u8) TokenType {
    return keywords.get(ident) orelse .IDENT;
}
