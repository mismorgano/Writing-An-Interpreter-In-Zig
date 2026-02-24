# Some notes about programming languages

Right now I just wanted to be able to implement an interpreter before digging in the theory
I already now about finite automata deterministic and non deterministic, regular languages, 
context-free languages, turing machines and little more. I heard they had to do with building programming
languages but I have no idea. In any case just before making sense on how these concepts fit together I
want to implement one by my own.

So I will following [Writing An Interpreter In Go][WAIG] for the `monkey` 
programming language I then want to read [Writing A Compiler In Go](https://compilerbook.com/) and realize 
there's an intermediate chapter [The Lost Chapter: A Macro System For Monkey](https://interpreterbook.com/lost/).
I'm planning in use a dedicated course from a big university but before that I just want to taste it.

So in this adventure I also wanted to learn a new programming language (maybe I should write it in `C`) in this case 
I wanted to learn [Zig](https://ziglang.org/) because of the hype (honestly) and the way in manages memory (of course I've
heard of [Rust](https://rust-lang.org/) and some time ago I tried to learn it but without a specific goal, just for the sake or learning, so I didn't. this time the goal is clear and I'm confident about it).

Right now I just finished the first chapter of [Writing An Interpreter In Go][WAIG] and now I'm in the chapter two about **parsing** and the implementation uses interfaces I read about it, watched some videos and implement one for the `Node` interface. 
I was stuck then I found (again) this awesome resource [Crafting Interpreters](https://craftinginterpreters.com/) which contains a little more about theory and has some historic and design notes.
So now I'm also reading it, I'll plasm some of the ideas there and I'll try to combine both of the books, *a ver qué sale*.

## Design decisions

[Crafting Interpreters][CI] writes about the following concepts/specification about its `Lex` programming language, it's broader 
than the one given by [Writing An Interpreter In Go][WAIG]. Neither of them talks about error handling, (it''l be interesting to dive  a little about it).
This includes about making the language static typed or dynamic typed, strong or weak typed, memory management, data types and their operations, what constitutes an expression?, what a statements?, are all statements expression? variables, control flow, functions, includes closures or not?, should be object oriented? in which way?
should follow a functional paradigm? What about a standard library?

Here there are the list of features for the `monkey` language implemented by [Writing An Interpreter In Go][WAIG]
- `C`-like syntax
- variable bindings
- integers and booleans
- arithmetic expressions
- built-in functions
- first-class and higher-order functions
- closures
- a string data structure/type
- an array data structure
- a hash data structure

And here is the list of features for the `lox`language implemented by [Crafting Interpreters][CI]
- `C`-like syntax
- dynamic typing
- automatic memory management trough a garbage collector
- built-in data types 
  - booleans
  - numbers (all double-precision floating point) 
  - string
  - nil (like null)
- expressions (produce a value), various kind
  - arithmetic
  - comparison and equality
  - logical operators
  - precedence and grouping
- statements (produce an effect)
  - blocks (to wrap a series of statements)
- variables
- control flow
- functions 
  - closures
- classes
  - instantiation and initialization
  - inheritance
- standard library
  - just the build-int `print` statement

We can see the difference between each one, although one it's more descriptive. 
In any case it would be fun to try to mashup both of them.


## Concepts

<dl>
  <dt>Self-hosting</dt>
  <dd>Implement a a compiler in the the same language it compiles.</dd>
</dl>
But, how does a first compiler for a language appear? It cannot use *self-hosting* yet but it can use:

<dl>
  <dt>Bootstrapping</dt>
  <dd>Implement a first version of a compiler in another language and use that version to make a compiler for the language and iterate over that one.</dd>
</dl>


## Historic notes


## Tools

There exists **compilers-compilers**, like [Lex](https://silcnitc.github.io/lex.html) that takes regular expression and outputs a `C` implementation corresponding the finite state machine (finite automata) that when compiled produces a *lexical analyzer*, or a *parse generator* like [Yacc](https://en.wikipedia.org/wiki/Yacc) both included in your distro, you can use it from your terminal!
Theres's a Yacc replacement called [Bison](https://en.wikipedia.org/wiki/GNU_bison).




[WAIG]:  https://interpreterbook.com/
[CI]: https://craftinginterpreters.com/