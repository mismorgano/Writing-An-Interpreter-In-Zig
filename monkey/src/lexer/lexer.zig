const token = @import("token");

pub const Lexer = struct {
    input: []const u8,
    position: usize = 0, // current position in input (points to current char)
    readPosition: usize = 0, // current reading position in input (after current char)
    ch: u8 = 0, // current char under examination
    line: u64 = 1,

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
                    break :sw self.newToken(.EQUAL, "==");
                } else {
                    break :sw self.newToken(.ASSIGN, "=");
                }
            },
            '+' => self.newToken(.PLUS, "+"),
            '-' => self.newToken(.MINUS, "-"),
            '!' => {
                if (self.peekChar() == '=') {
                    self.readChar();
                    break :sw self.newToken(.NOT_EQUAL, "!=");
                } else {
                    break :sw self.newToken(.BANG, "!");
                }
            },
            '*' => self.newToken(.ASTERISK, "*"),
            '/' => self.newToken(.SLASH, "/"),
            '<' => self.newToken(.LESS, "<"),
            '>' => self.newToken(.GREATER, ">"),
            ';' => self.newToken(.SEMICOLON, ";"),
            ',' => self.newToken(.COMMA, ","),
            '(' => self.newToken(.LEFT_PAREN, "("),
            ')' => self.newToken(.RIGHT_PAREN, ")"),
            '{' => self.newToken(.LEFT_PAREN, "{"),
            '}' => self.newToken(.RIGHT_BRACE, "}"),
            0 => self.newToken(.EOF, ""), // because it points to null-terminated byte arrays.
            else => {
                if (isLetter(self.ch)) {
                    const identifier = self.readIdentifier();
                    const t = token.lookupIdent(identifier);
                    return self.newToken(t, identifier);
                } else if (isDigit(self.ch)) {
                    const number = self.readNumber();
                    return self.newToken(.INTEGER, number);
                } else {
                    return self.newToken(.ILLEGAL, "");
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
    pub fn newToken(self: *Lexer, tokenType: token.TokenType, literal: []const u8) token.Token {
        return .{ .type = tokenType, .literal = literal, .line = self.line };
    }
};

fn isDigit(ch: u8) bool {
    return '0' <= ch and ch <= '9';
}

fn isLetter(ch: u8) bool {
    return 'a' <= ch and ch <= 'z' or 'A' <= ch and ch <= 'Z' or ch == '_';
}
