const token = @import("../token/token.zig");

pub const Lexer = struct {
    input: []const u8,
    position: usize = 0, // current position in input (points to current char)
    readPosition: usize = 0, // current reading position in input (after current char)
    ch: u8 = 0, // current char under examination

    pub fn init(input: []const u8) *Lexer {
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

    pub fn nextToken(self: *Lexer) token.Token {
        const tok: token.Token = switch (self.ch) {
            '=' => .{ .Type = .ASSIGN, .Literal = self.ch },
            ';' => .{ .Type = .SEMICOLON, .Literal = self.ch },
            '(' => .{ .Type = .LPAREN, .Literal = self.ch },
            ')' => .{ .Type = .RPAREN, .Literal = self.ch },
            ',' => .{ .Type = .COMMA, .Literal = self.ch },
            '+' => .{ .Type = .PLUS, .Literal = self.ch },
            '{' => .{ .Type = .LBRACE, .Literal = self.ch },
            '}' => .{ .Type = .RBRACE, .Literal = self.ch },
            0 => .{ .Type = token.EOF, .Literal = "" },
        };

        self.readChar();
        return tok;
    }

    // utility function not used
    pub fn newToken(tokenType: token.TokenType, ch: u8) token.Token {
        token.Token{ .Type = tokenType, .Literal = ch };
    }
};
