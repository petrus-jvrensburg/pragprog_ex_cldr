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
    <p>Now fire-up the first livebook<footnote>
        <p><url>
      https://github.com/petrus-jvrensburg/pragprog_ex_cldr/blob/main/livebooks_external/01-up-and-running.livemd</url></p>
      </footnote>
      so that we can get started.</p>
    <sect2>
      <title>
        Example: Displaying dates and times
      </title>

      <p>Let's look at the timestamp of the first commit to the Elixir git repo at <url>
        https://github.com/elixir-lang/elixir</url></p>

      <code language="session">
        % git log --reverse commit 337c3f2d569a42ebd5fcab6fef18c5e012f9be5b
        Author: José Valim <jose.valim@gmail.com>
        Date: Sun Jan 9 09:46:08 2011 +0100
        
            First commit.
      </code>

      <p>So, how long ago was that first commit made?</p>

      <code language="elixir">
        > first_commit = ~U[2011-01-09 08:46:08Z]
        > now = DateTime.utc_now()
        > Cldr.DateTime.Relative.to_string!(first_commit, relative_to: now)

        "13 years ago"
      </code>

      <p> Here we are dealing with the timestamps in a relative sense, i.e. as a <emph>duration</emph>. Without
        relying on the CLDR, this could have added a lot of complexity to our code. But luckily for
        us, <inlinecode>ex_cldr</inlinecode> reduces that complexity to a single call to <inlinecode>
        Cldr.DateTime.Relative.to_string!/3</inlinecode>. </p>

      <p>
        Note that this same function works for any length of duration, both positive and negative:
</p>

      <code language="elixir">
        > durations_in_seconds = [
        -30,
        -300,
        -30_000,
        -300_000,
        -3_000_000,
        -30_000_000,
        -300_000_000,
        300_000_000
        ]
        > Enum.map(durations_in_seconds, fn duration ->
        Cldr.DateTime.Relative.to_string!(DateTime.add(now, duration, :second), relative_to: now)
        end)

        ["30 seconds ago", "5 minutes ago", "8 hours ago", "3 days ago", "last month", "11 months
        ago",
        "10 years ago", "in 10 years"]
</code>

      <p>
        Later-on we'll see how to display dates and times correctly for specific locales (eg.
        UK-english). But to display a timestamp in the default US-English is also a single function
        call.
</p>
      <code language="elixir">
        > Cldr.DateTime.to_string!(first_commit)
        "Jan 9, 2011, 8:46:08 AM"
        > Cldr.DateTime.to_string!(first_commit, format: :long)
        "January 9, 2011, 8:46:08 AM UTC"
        > Cldr.DateTime.to_string!(first_commit, format: :short)
        "1/9/11, 8:46 AM"
</code>

      <p>And we can use format strings<footnote>
          <p><url>https://hexdocs.pm/ex_cldr_dates_times/readme.html#format-strings</url></p>
        </footnote>
        when we want to have more control:</p>
      <code language="elixir">
        > Cldr.DateTime.to_string!(first_commit, format: "dd-MM-yyyy hh:mm")
        "09-01-2011 08:46"
</code>

      <p>
        The same approach that works for DateTime variables also extends to Date and Time variables
        respectively, e.g:
</p>
      <code language="elixir">
        > Cldr.Date.to_string!(~D[2011-01-09])
        "Jan 9, 2011"
        > Cldr.Time.to_string!(~T[08:46:08])
        "8:46:08 AM"
</code>

    </sect2>
    <sect2>
      <title>
        Example: Numbers and currencies
      </title>
      <p>
        In the interfaces that we build, it's often useful to format numbers to make them more
        legible. We could do that the hard way, or we can let _ex_cldr_ take care of it for us:
</p>
      <code language="elixir">
        > big_number = 91_825_808.102384
        > Cldr.Number.to_string!(big_number)
        "91,825,808.102"
        > Cldr.Number.to_string!(big_number, round_nearest: 1_000_000)
        "92,000,000"
</code>

      <p>
        And the same approach that works for regular numbers, also works for currencies. Here we use
        the <inlinecode>ex_money</inlinecode> package that builds on top of <inlinecode>ex_cldr</inlinecode>:
</p>

      <code language="elixir">
        > Money.to_string!(Money.new(:USD, "123.45"))
        "$123.45"
      </code>
    </sect2>
    <sect2>
      <title>
        Example: Configuring locales
      </title>
      <p>Now the magic happens.</p>

      <p>We saw above how simple it is to display a dates or times in the
        default locale (en-US). Now, by just configuring a few more locales, and specifying which
        one we want, we can use exaclty the same code from above to display dates and times
        to individual users in the locale that they might expect.</p>

      <p>In the <emph>Notebook dependencies and setup</emph> section at the top, you'll notice that we added a
        few more interesting locales. We'll configure this livebook's Elixir process to each of
        those locales, to see how the variables in the examples above would be formatted.
      </p>
      <p>
        We'll start by wrapping some of the examples above in a function:
      </p>
      <code language="elixir">
        defmodule Helper do
          def variable_formatting_samples() do
            first_commit = ~U[2011-01-09 08:46:08Z]

            [
              Cldr.DateTime.Relative.to_string!(first_commit, relative_to: DateTime.utc_now()),
              Cldr.DateTime.to_string!(first_commit),
              Cldr.DateTime.to_string!(first_commit, format: :long),
              Cldr.DateTime.to_string!(first_commit, format: :short),
              Cldr.Date.to_string!(~D[2011-01-09]),
              Cldr.Time.to_string!(~T[08:46:08]),
              Cldr.Number.to_string!(91_825_808.102384, round_nearest: 1_000_000),
              Money.to_string!(Money.new(:USD, "123.45"))
            ]
          end
        end
</code>

      <p>Now, we configure the current Elixir process as it might be set up for a Hindi user:</p>
      <code language="elixir">
        > Cldr.put_locale("hi")
</code>

      <p>And just like that, all of the variables display exactly as the user would expect them to:
      </p>

      <code language="elixir">
        > Helper.variable_formatting_samples()
        ["13 वर्ष पहले", "9 जन॰ 2011, 8:46:08 am",
        "9 जनवरी 2011, 8:46:08 am UTC", "9/1/11, 8:46 am", "9 जन॰ 2011", "8:46:08 am",
        "9,20,00,000", "$123.45"]
</code>

      <p>Similarly for German, (Brazilian) Portuguese, or even UK English users:</p>
      <code language="elixir">
        > Cldr.put_locale("de")
        > Helper.variable_formatting_samples()
        ["vor 13 Jahren", "09.01.2011, 08:46:08", "9. Januar 2011, 08:46:08 UTC", "09.01.11, 08:46",
        "09.01.2011", "08:46:08", "92.000.000", "12.345,00 $"]
        > Cldr.put_locale("pt")
        > Helper.variable_formatting_samples()
        ["há 13 anos", "9 de jan. de 2011 08:46:08", "9 de janeiro de 2011 08:46:08 UTC",
        "09/01/2011 08:46", "9 de jan. de 2011", "08:46:08", "92.000.000", "US$ 12.345,00"]
        > Cldr.put_locale("en-GB")
        > Helper.variable_formatting_samples()
        ["13 years ago", "9 Jan 2011, 08:46:08", "9 January 2011, 08:46:08 UTC", "09/01/2011,
        08:46",
        "9 Jan 2011", "08:46:08", "92,000,000", "US$123.45"]
</code>

      <p>
        Notice here that our code stayed exaclty the same for each of these users. The only thing
        that changed is that we specified a locale (for the current Elixir process) using
        <inlinecode>CLDR.put_locale/1</inlinecode>, and <inlinecode>ex_cldr</inlinecode> was able to display all of the variables in the expected
        format for each of the locales that was configured in the <emph>Notebook dependencies and setup</emph>
        section.
</p>
    </sect2>
    <!-- <sect2>
      <title>
        Example: Territories, languages, and other reference entities
      </title>
      <p>TODO</p>
    </sect2> -->
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
          <p>
            <url>https://en.wikipedia.org/wiki/ISO_week_date</url>
          </p>
        </footnote>
        and the US's National Retail Federation calendar<footnote>
          <p>
            <url>https://nrf.com/resources/4-5-4-calendar</url>
          </p>
        </footnote>,
        together with Fiscal calendars for many territories. But we can also use <inlinecode>
        Cldr.Calendar.new/3</inlinecode> to configure our own month-based, or week-based calendars. </p>

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