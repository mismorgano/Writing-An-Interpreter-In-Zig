const std = @import("std");

/// Based on the programming syntax design, recognized lexemes.
pub const TokenType = enum {
    ILLEGAL,
    EOF,
    LINE_COMMENT,

    // Identifiers + literals
    IDENTIFIER,
    INTEGER, // and decimal is left
    STRING,

    // Operators
    ASSIGN, // =
    PLUS, // +
    MINUS, // -
    BANG, // !
    ASTERISK, // *
    SLASH, // /

    LESS, // <
    LESS_EQUAL, // <=
    GREATER, // >=
    GREATER_EQUAL, // >=

    EQUAL, // ==
    NOT_EQUAL, // !=
    // Delimiters
    COMMA, // ,
    SEMICOLON, // ;
    DOT, // . for classes

    LEFT_PAREN, // (
    RIGHT_PAREN, // )
    LEFT_BRACE, // {
    RIGHT_BRACE, // }
    // keywords
    FUNCTION, // function
    LET, // let
    TRUE, // true
    FALSE, // false
    IF, // if
    ELSE, // else
    RETURN, // return
    AND, // and
    OR, // or
    CLASS, // class
    SUPER, // super
    THIS, // this
    FOR, // for
    WHILE, // while
    NIL, // nil
};

/// Includes information about 'where' an error could occur.
pub const Token = struct {
    type: TokenType,
    literal: []const u8,
    line: u64,
};

const keywords = std.StaticStringMap(TokenType).initComptime(.{
    .{ "fn", .FUNCTION },
    .{ "let", .LET },
    .{ "true", .TRUE },
    .{ "false", .FALSE },
    .{ "if", .IF },
    .{ "else", .ELSE },
    .{ "return", .RETURN },
    .{ "and", .AND },
    .{ "or", .OR },
    .{ "class", .CLASS },
    .{ "super", .SUPER },
    .{ "this", .THIS },
    .{ "for", .FOR },
    .{ "while", .WHILE },
    .{ "nil", .NIL },
});

pub fn lookupIdent(ident: []const u8) TokenType {
    return keywords.get(ident) orelse .IDENTIFIER;
}
