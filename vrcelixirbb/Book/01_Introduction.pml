<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.intro">
  <title>Up &amp; running with Livebook</title>
  <storymap>
<markdown>
Why do I want to read this?
: Because you're uncertain about these CLDR libraries that you've heard about, or how they
work. You want to get a quick feel for them before committing to reading a book

What will I learn?
: How to run ex_cldr libraries locally, in an interactive notebook, to solve interresting
problems that you have likely encoutered in your own applications.

What will I be able to do that I couldn't do before?
: Format common types of variables at runtime, including dates, durations, numbers and
currency values. Then translate them in a flash, into a wide range of languages simply by
configuring the locales.

Where are we going next, and how does this fit in?
: Next we'll look at some of the structured data that's underpinning these
internationalization libraries, to get a feel for how you might simplify your own code by
relying on them where appropriate.
</markdown>
  </storymap>
  <sect1>
    <title>
      Introduction
    </title>
    <p>
      TODO
    </p>
  </sect1>

  <sect1>
    <title>
      Installing Livebook
    </title>
    <p>
      If you are new to Livebook, we recommend using the desktop installer. It's the fastest way to
      get up &amp; running, even if you don't have Elixir installed on your machine.
    </p>
    <p>
      Alternatively, if you already have Elixir set up locally, it's also really easy to run the
      latest Livebook directly from source:
    </p>

    <code language="session">
      git clone https://github.com/livebook-dev/livebook.git
      cd livebook
      mix deps.get --only prod

      # Run the Livebook server
      MIX_ENV=prod mix phx.server
    </code>

    <p> Once you have Livebook running, take a few moments to click through the sample livebooks in
      the <emph>Learn</emph> section. Specifically, the <emph>Welcome to Livebook</emph> examples
      will give you more than you need for running the code that's shipped with this book. </p>

    <p> At their core, the notebooks that we'll work with in Livebook are just Markdown files<footnote>
        <p>Livebook uses the <fileextension>livemd</fileextension> extension to denote a subset of
      Markdown.</p>
      </footnote> which are annotated in a special way to distinguish between
      different types of cells, like prose, code, diagrams or a wide array of other "smart cells"
      defined using the Kino library. The cells can all be edited directly from your browser, and
      you can execute them all sequentially to see their output. </p>

    <p>
      So in a certain sense, coding in Livebook is like coding in the terminal, but on steroids: you
      are working with
      high-level UI components that leverage the functionality that a browser interface
      brings to the table, like file-uploads, image previews, etc.
      And you can save your work easily, and jump around between cells, without losing context,
      since they hang on to their state between execution runs. All of this while
      retaining full control over the code and the data that you're working with.
    </p>
  </sect1>

  <sect1>
    <title>
      Up &amp; Running
    </title>
    <p>TODO</p>
    <sect2>
      <title>
        Example: Displaying dates and times
      </title>
      <p>TODO</p>
    </sect2>
    <sect2>
      <title>
        Example: Displaying durations
      </title>
      <p>TODO</p>
    </sect2>
    <sect2>
      <title>
        Example: Configuring locales
      </title>
      <p>TODO</p>
    </sect2>
    <sect2>
      <title>
        Example: Territories, languages, and other reference entities
      </title>
      <p>TODO</p>
    </sect2>
  </sect1>

  <sect1>
    <title>
      What's included in the ex_cldr ecosystem?
    </title>

    <p> Having the <inlinecode>ex_cldr</inlinecode> base-package installed allows us to configure
      our application for supporting specific locales, but it doesn't let us do much more than that.
      The heavy lifting is done by other, related packages, that each handle some specific type of
      value at runtime. Some of the most useful of these include: </p>

    <sect2>
      <title>ex_cldr_numbers</title>
      <p> This package lets us format numbers consistently, including delimeters, decimals or spaces
        where expected, according to the user's locale. for example, we can use it to display the
        integer 1000000 consistently as <emph>1,000,000</emph> in the US, <emph>1.000.000</emph> in
        Brazil or <emph>10,00,000</emph> in India, as users in those countries would expect. And it
        comes with a range of builtin formats for handling things like percentages, scientific
        notation or accounting format, while supporting user-defined formatting rules for those
        nasty edge-cases. </p>

      <p> But beyond simple formatting, the package also lets us convert between number systems, for
        example to display an integer in Roman numerals, or to show numbers in Arabic or Devanagari
        script. So, without much effort, we can use it to display the number 123 as <emph>CXXIII</emph>
        , <emph>١٢٣</emph> or <emph>१२३</emph> wherever that may be appropriate. </p>

      <p>
        Parsing of numbers is also supported, taking into account the locale of the input string
        and the conventions around decimals and delimeters that are implied.
      </p>

      <p> Formatting and parsing of <emph>currency values</emph> are also supported by <inlinecode>
        ex_cldr_numbers</inlinecode>. But we can go further and by reaching for the <inlinecode>
        ex_money</inlinecode> package which lets us do things like tracking exchange rates,
        converting between currencies and persisting monetary values reliably to the database. </p>
    </sect2>

    <sect2>
      <title>ex_cldr_calendars</title>

      <p> This package implements a set of convenient functions for working with <inlinecode>
        Date.Range</inlinecode> values across different calendars. For example, it can help us
        determine that today's date falls into the "Q4" quarter in the US, and makes it simple to
        find the start and end date for this quater. It then lets us step through quarters using <inlinecode>
        Cldr.Calendar.next/2</inlinecode> and <inlinecode>Cldr.Calendar.previous/2</inlinecode>. </p>

      <p> A great use-case for this would be a reporting dashboard, where <inlinecode>
        ex_cldr_calendars</inlinecode> makes it easy for us to calculate the dates that we need for
        performing aggregate queries on the database, for comparing the <emph>current quarter</emph>
        to the <emph>previous quarter</emph>, or any other range of interest: like the current week,
        month or year. </p>

      <p> Then, using the functions defined in <inlinecode>Cldr.Calendar.Kday</inlinecode>, we can
        find the first, last, nearest and nth days of the week from a date. For example: "find the
        2nd Tuesday in November". This can be great for calculating certain public holidays, or the
        start &amp; end of daylight savings time in certain countries. </p>

      <p> A few calendars are built-in, e.g. the default Gregorian calendar used through most
        countries, as well as the ISO week calendar<footnote>
          <p><url>https://en.wikipedia.org/wiki/ISO_week_date</url></p>
        </footnote> and the US's National Retail Federation calendar<footnote>
          <p><url>https://nrf.com/resources/4-5-4-calendar</url></p>
        </footnote>, together with Fiscal
        calendars for many territories. But we can also use <inlinecode>Cldr.Calendar.new/3</inlinecode>
        to configure our own month-based, or week-based calendars. </p>

      <p>
        Additionally, dedicated packages exist for more specific
        calendars like the Coptic, Persian, Japanese and Ethiopic. And the lunisolar calendars
        used in China, Japan and Korea are also supported in this way.
      </p>

      <p> Lastly, <inlinecode>ex_cldr_calendars</inlinecode> lets us localize durations, for
        example: </p>

      <code language="elixir">
        > {:ok, duration} = Cldr.Calendar.Duration.new(~D[2025-01-01], ~D[2025-12-31])
        > Cldr.Calendar.Duration.to_string(duration)
        "11 months and 30 days"
      </code>
    </sect2>
    <sect2>
      <title>ex_cldr_dates_times</title>

      <p>TODO</p>

      <!-- Date, Time and DateTime localization, internationalization and formatting functions using
    the Common Locale Data Repository (CLDR).

    Localize using \textit{to\_string} - with builtin format specifiers
    custom formatting is possible 

    Localized relative time / date / datetime formatting

    Localized interval formatting -->

    </sect2>
    <sect2>
      <title>ex_cldr_units</title>

      <p>TODO</p>

      <!-- Unit formatting (volume, area, length, ...), conversion and arithmetic functions based
      upon
    the Common Locale Data Repository (CLDR).
    ex\_cldr\_units\_sql -->
    </sect2>

    <figure id="ex_cldr_dependency_tree">
      <imagedata fileref="images/01_Introduction/deps_tree.png" align="center"
        width="80%" />
      <p>CLDR-related packages and the dependencies between them.</p>
    </figure>
  </sect1>

  <sect1>
    <title>
      How does this fit into my Elixir application?
    </title>
    <p>TODO</p>
    <p>TL/DR: alongside gettext</p>
  </sect1>

  <sect1>
    <title>
      In summary
    </title>
    <p>TODO</p>
  </sect1>
</chapter>