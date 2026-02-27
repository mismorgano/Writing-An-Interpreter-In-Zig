const token = @import("token");

/// Structure for scanning and tokenize input.
/// It receives only the input as a []const u8
pub const Lexer = struct {
    input: []const u8,
    position: usize = 0, // current position in input (points to current char) and start of token
    readPosition: usize = 0, // current reading position in input (after current char) 'possibly end' of token
    ch: u8 = 0, // current char under examination
    line: u64 = 1, // tracks what source line

    pub fn init(input: []const u8) Lexer {
        var lexer = Lexer{ .input = input };
        lexer.readChar();
        return lexer;
    }

    fn isAtEnd(self: *Lexer) bool {
        return self.readPosition >= self.input.len;
    }

    /// Only moves our readPosition (current end) by one
    fn advance(self: *Lexer) void {
        if (!self.isAtEnd()) {
            self.ch = self.input[self.readPosition];
            self.readPosition += 1;
        }
    }

    /// Advances the start position. 'Consume' the characters until readPosition(current end)
    fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    /// See one character ahead
    pub fn peekChar(self: *Lexer) u8 {
        if (self.readPosition >= self.input.len) {
            return 0;
        } else {
            return self.input[self.readPosition];
        }
    }

    /// Advances readPosition until end of number
    pub fn readNumber(self: *Lexer) []const u8 {
        while (isDigit(self.peekChar())) {
            self.advance();
        }
        return self.input[self.position..self.position];
    }

    pub fn nextToken(self: *Lexer) token.Token {
        self.skipWhitespace();

        const tok: token.Token = sw: switch (self.ch) { // not self.peekChar
            '=' => {
                if (self.peekChar() == '=') {
                    self.advance();
                    break :sw self.addToken(.EQUAL);
                } else {
                    break :sw self.addToken(.ASSIGN);
                }
            },
            '+' => self.addToken(.PLUS),
            '-' => self.addToken(.MINUS),
            '!' => {
                if (self.peekChar() == '=') {
                    self.advance();
                    break :sw self.addToken(.NOT_EQUAL);
                } else {
                    break :sw self.addToken(.BANG);
                }
            },
            '*' => self.addToken(.ASTERISK),
            '/' => self.addToken(.SLASH),
            '<' => self.addToken(.LESS),
            '>' => self.addToken(.GREATER),
            ';' => self.addToken(.SEMICOLON),
            ',' => self.addToken(.COMMA),
            '(' => self.addToken(.LEFT_PAREN),
            ')' => self.addToken(.RIGHT_PAREN),
            '{' => self.addToken(.LEFT_BRACE),
            '}' => self.addToken(.RIGHT_BRACE),
            0 => .{ .type = .EOF, .literal = "", .line = self.line }, // because it points to null-terminated byte arrays.
            else => default: {
                if (isLetter(self.ch)) {
                    const identifier = self.readIdentifier();
                    const t = token.lookupIdent(identifier);
                    break :default self.addToken(t);
                } else if (isDigit(self.ch)) {
                    _ = self.readNumber();
                    break :default self.addToken(.INTEGER);
                } else {
                    break :default self.addToken(.ILLEGAL);
                }
            },
        };

        self.readChar(); // we need to advance our lexer

        return tok;
    }

    pub fn readIdentifier(self: *Lexer) []const u8 {
        while (isLetter(self.peekChar())) {
            self.advance();
        }
        return self.input[self.position..self.readPosition];
    }

    pub fn skipWhitespace(self: *Lexer) void {
        skip: switch (self.ch) {
            ' ', '\t', '\r' => {
                self.readChar();
                continue :skip self.ch;
            },
            '\n' => {
                self.line += 1;
                self.readChar();
                continue :skip self.ch;
            },
            else => {},
        }
    }

    fn addToken(self: *Lexer, tokenType: token.TokenType) token.Token {
        const literal = self.input[self.position..self.readPosition];
        return .{ .type = tokenType, .literal = literal, .line = self.line };
    }
    // utility function not used
    fn newToken(self: *Lexer, tokenType: token.TokenType, literal: []const u8) token.Token {
        return .{ .type = tokenType, .literal = literal, .line = self.line };
    }
};

fn isDigit(ch: u8) bool {
    return '0' <= ch and ch <= '9';
}

fn isLetter(ch: u8) bool {
    return 'a' <= ch and ch <= 'z' or 'A' <= ch and ch <= 'Z' or ch == '_';
}
