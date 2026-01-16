const std = @import("std");

pub const TokenType = []const u8;

pub const Token = struct {
    Type: TokenType,
    Literal: []const u8,
};

// Token types

pub const ILLEGAL = "ILLEGAL";
pub const EOF = "EOF";

// Identifiers + literals
pub const IDENT = "IDENT";
pub const INT = "INT";

// Operators
pub const ASSIGN = "=";
pub const PLUS = "+";

// Delimiters
pub const COMMA = ",";
pub const SEMICOLON = ";";

pub const LPAREN = "(";
pub const RPAREN = ")";
pub const LBRACE = "{";
pub const RBRACE = "}";

// Keywords
pub const FUNCTION = "FUNCTION";
pub const LET = "LET";

const keywords = std.StaticStringMap(TokenType).initComptime(
    .{
        .{ "fn", FUNCTION },
        .{ "let", LET },
    },
);

pub fn lookupIdent(ident: []const u8) TokenType {
    return keywords.get(ident) orelse IDENT;
}
