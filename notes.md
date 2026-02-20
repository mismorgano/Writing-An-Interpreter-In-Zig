# Some notes about programming languages

Right now I just wanted to be able to implements an interpreter before digging in the theory
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




[WAIG]:  https://interpreterbook.com/
[CI]: https://craftinginterpreters.com/