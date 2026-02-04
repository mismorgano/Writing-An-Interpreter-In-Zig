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
pub const MINUS = "-";
pub const BANG = "!";
pub const ASTERISK = "*";
pub const SLASH = "/";

pub const LT = "<";
pub const GT = ">";

pub const EQ = "==";
pub const NOT_EQ = "!=";

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
pub const TRUE = "TRUE";
pub const FALSE = "FALSE";
pub const IF = "IF";
pub const ELSE = "ELSE";
pub const RETURN = "RETURN";

const keywords = std.StaticStringMap(TokenType).initComptime(.{
    .{ "fn", FUNCTION },
    .{ "let", LET },
    .{ "true", TRUE },
    .{ "false", FALSE },
    .{ "if", IF },
    .{ "else", ELSE },
    .{ "return", RETURN },
});

pub fn lookupIdent(ident: []const u8) TokenType {
    return keywords.get(ident) orelse IDENT;
}
