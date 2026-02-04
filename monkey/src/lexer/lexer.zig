const token = @import("token");

pub const Lexer = struct {
    input: []const u8,
    position: usize = 0, // current position in input (points to current char)
    readPosition: usize = 0, // current reading position in input (after current char)
    ch: u8 = 0, // current char under examination

    pub fn init(input: []const u8) Lexer {
        var lexer = Lexer{ .input = input };
        lexer.readChar();
        return lexer;
    }

    pub fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn peekChar(self: *Lexer) u8 {
        if (self.readPosition >= self.input.len) {
            return 0;
        } else {
            return self.input[self.readPosition];
        }
    }

    pub fn readNumber(self: *Lexer) []const u8 {
        const position = self.position;
        while (isDigit(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    pub fn nextToken(self: *Lexer) token.Token {
        self.skipWhitespace();

        const tok: token.Token = sw: switch (self.ch) {
            '=' => {
                if (self.peekChar() == '=') {
                    self.readChar();
                    break :sw .{ .Type = token.EQ, .Literal = "==" };
                } else {
                    break :sw .{ .Type = token.ASSIGN, .Literal = "=" };
                }
            },
            '+' => .{ .Type = token.PLUS, .Literal = "+" },
            '-' => .{ .Type = token.MINUS, .Literal = "-" },
            '!' => {
                if (self.peekChar() == '=') {
                    self.readChar();
                    break :sw .{ .Type = token.NOT_EQ, .Literal = "!=" };
                } else {
                    break :sw .{ .Type = token.BANG, .Literal = "!" };
                }
            },
            '*' => .{ .Type = token.ASTERISK, .Literal = "*" },
            '/' => .{ .Type = token.SLASH, .Literal = "/" },
            '<' => .{ .Type = token.LT, .Literal = "<" },
            '>' => .{ .Type = token.GT, .Literal = ">" },
            ';' => .{ .Type = token.SEMICOLON, .Literal = ";" },
            ',' => .{ .Type = token.COMMA, .Literal = "," },
            '(' => .{ .Type = token.LPAREN, .Literal = "(" },
            ')' => .{ .Type = token.RPAREN, .Literal = ")" },
            '{' => .{ .Type = token.LBRACE, .Literal = "{" },
            '}' => .{ .Type = token.RBRACE, .Literal = "}" },
            0 => .{ .Type = token.EOF, .Literal = "" },
            else => {
                if (isLetter(self.ch)) {
                    const identifier = self.readIdentifier();
                    const t = token.lookupIdent(identifier);
                    return .{ .Type = t, .Literal = identifier };
                } else if (isDigit(self.ch)) {
                    const number = self.readNumber();
                    return .{ .Type = token.INT, .Literal = number };
                } else {
                    return .{ .Type = token.ILLEGAL, .Literal = "" };
                }
            },
        };

        self.readChar();
        return tok;
    }

    pub fn readIdentifier(self: *Lexer) []const u8 {
        const position = self.position;
        while (isLetter(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    pub fn skipWhitespace(self: *Lexer) void {
        skip: switch (self.ch) {
            ' ', '\t', '\n', '\r' => {
                self.readChar();
                continue :skip self.ch;
            },
            else => {},
        }
    }

    // utility function not used
    pub fn newToken(tokenType: token.TokenType, ch: u8) token.Token {
        .{ .Type = tokenType, .Literal = @as([]const u8, ch) };
    }
};

fn isDigit(ch: u8) bool {
    return '0' <= ch and ch <= '9';
}

fn isLetter(ch: u8) bool {
    return 'a' <= ch and ch <= 'z' or 'A' <= ch and ch <= 'Z' or ch == '_';
}
