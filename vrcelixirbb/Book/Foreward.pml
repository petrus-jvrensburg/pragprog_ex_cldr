<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<markdown>
# Foreward

Back in 2004, I remember going to University to access the internet and, more often than not, I'd rekindle with the `�` character, which is the famous Unicode Replacement Character, used by browsers whenever they detected something invalid on the page. At the time, there was no universal agreement on how to encode digital documents, and different regions across the world chose different rules to map bytes to characters.

Years later, when I was writing a web crawler, I remember studying the [charguess library](https://sourceforge.net/projects/libcharguess/) as an attempt to best guess the encoding of a web page. Theoretically, a web page should include its encoding in the response header, but more often than not, it was either missing or just plain invalid.

Nowadays, the web has pretty much agreed on using the Unicode standard and UTF-8 encoding for web pages. At the time of writing, Unicode defines 149813 characters and 161 scripts used in various ordinary, literary, academic, and technical contexts (including emojis!), embracing a wide range of written languages and communication styles. Still, every once in a while, I may receive an email beginning with "Hello JosÃ©!".

While the problems I faced early in my career are (mostly) in the past, they opened up my mind to the different challenges different languages, cultures, and regions may face when working together.

When I started working on Elixir, it was essential for us to support Unicode. I wanted `String.upcase("josé")` to return `"JOSÉ"` and not `"JOSé"`. The latter is what most programming languages returned at the time, often weighted by the needs to keep compatibility with existing codebases. Elixir, being new, could afford to start fresh.

Later on, when we added built-in support for calendar types in Elixir, such as `Date` and `DateTime`, they were designed from day one to support multiple calendars, and not only the Gregorian calendar commonly used in the west. And, even when using the same calendar, we still fail to agree if the week starts on Sunday or Monday!

When Elixir evolves in these new directions, we rely on the input from the community to ensure our designs go beyond a single person's understanding of the world. And much of the feedback we receive comes from creators and maintainers of the libraries used throughout this book.

That's the exciting bit: the Elixir libraries you will learn in this book have already been a big influence on the code you write today, even if you have never installed them. They have helped inform many crucual design decisions in the language itself. And, once you master them, you will not only become a better Elixir developer, but also gain a greater understanding of the world around you.

I hope you will enjoy this book as much as I did,

--- José Valim, Tenczynek, 2023
</markdown>
