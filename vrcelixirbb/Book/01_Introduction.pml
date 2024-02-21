<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.intro">
<title>Up &amp; running with Livebook</title>
<storymap>
<markdown>
Why do I want to read this?
: Because you're uncertain about these internationalization libraries that you've heard about, or how they work. You want to get a quick feel for them before committing to reading a book

What will I learn?
: How to run ex_cldr libraries locally, in an interactive notebook, to solve interresting problems that you have likely encoutered in your own applications.

What will I be able to do that I couldn't do before?
: Translate variables into a wide range of languages / locales at runtime, including dates, durations, numbers and currency values.

Where are we going next, and how does this fit in?
: Next we'll look at some of the structured data that's underpinning these internationalization libraries, to get a feel for how you might simplify your own code by relying on them where appropriate.
</markdown>
</storymap>

<sect1>
  <title>
    Installing Livebook
  </title>
  <markdown>
  If you are new to Livebook, we recommend using the desktop installer. It's the fastest way to get up &amp; running, even if you don't have Elixir installed on your machine.

  Alternatively, if you already have Elixir set up locally, it's also really easy to run the latest Livebook directly from source:
  </markdown>

  <code>
  git clone https://github.com/livebook-dev/livebook.git
  cd livebook
  mix deps.get --only prod

  # Run the Livebook server
  MIX_ENV=prod mix phx.server
  </code>
  
  <markdown>
  Once you have Livebook running, take a few moments to click through the sample 
  livebooks in the _Learn_ section. Specifically, the _Welcome to Livebook_
  examples will give you more than you need for running the code that's shipped 
  with this book.

  At their core, the notebooks that we'll work with in Livebook are just Markdown 
  files[^fn-eg] which are annotated in a special way to distinguish between different types of "cells", 
  like prose, code, diagrams or a wide array of other "smart cells" defined using the 
  Kino library. The cells can all be edited directly from your browser, and you can execute them all 
  sequentially to see their output. 

  [^fn-eg]: Livebook uses the _.livemd_ extension to denote a subset of Markdown.

  So in a certain sense, coding in Livebook is like coding in the terminal, but on steroids: you are working with
  high-level UI components that leverage the functionality that a browser interface 
  brings to the table, like file-uploads, image previews, etc. 
  And you can save your work easily, and jump around between cells, without losing context, 
  since they hang on to their state between execution runs. All of this while 
  retaining full control over the code and the data that you're working with.
  </markdown>
</sect1>

<sect1>
  <title>
    Using ex_cldr libraries at runtime
  </title>
  <sect2>
    <title>
      numbers
    </title>
  </sect2>
  <sect2>
    <title>
      dates
    </title>
  </sect2>
  <sect2>
    <title>
      durations
    </title>
  </sect2>
  <sect2>
    <title>
      currencies (with ex_money)
    </title>
  </sect2>
</sect1>

<sect1>
  <title>
    What's included in the ex_cldr ecosystem?
  </title>
</sect1>

<sect1>
  <title>
    How does this fit into my Elixir application?
  </title>
  <p>TL/DR: alongside gettext</p>
</sect1>

<sect1>
  <title>
    What's next?
  </title>
</sect1>
</chapter>
