<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.beyond_translation">
  <title>Beyond Translation</title>
<storymap>
<markdown>
Why do I want to read this?
: You want to get a feel for what other benefits these CLDR libraries might provide. You know
they can translate stuff, but that's not terribly exciting on its own.

What will I learn?
: You will learn about some of the standards-based datasets that are used by the ex_cldr
libraries, and are available in your own code, including countries, currencies, languages,
calendars and units of measure.

What will I be able to do that I couldn't do before?
: You will be able to validate iso codes for standard entities, and convert them to
user-friendly display names. You will also be able to convert between currencies and units of
measure.

Where are we going next, and how does this fit in?
: Next, we'll see how too get these libraries set up in your own Elixir applications, and how
to determine the locale of your users.
</markdown>
  </storymap>

  <sect1>
    <title>
      Introduction
    </title>
    <p> What makes the CLDR so useful for internationalization (its primary purpose), is the fact
      that it's built on structured data, often including standards-based records that can be
      referenced reliably in our code. Things like countries, currencies and languages can be a real
      pain to keep track of ourselves, but with the <inlinecode>ex_cldr</inlinecode> suite of
      libraries, we don't have to, because they have it all baked-in. </p>

    <p> In this chapter we'll learn how to make the best use of this structured data inside our own
      applications, building various form inputs for things like countries, currencies and
      languages, and then validating the input from these forms using <emph>Ecto changesets</emph>. </p>

    <p>
      The beauty of it is that we'll be building robust application code, that can handle a wide
      range of standards-based entities, without adding
      any new database tables that we would have to maintain ourselves. Rather, we'll learn how to
      leverage the CLDR dataset, which is updated periodically by the Unicode Consortium.
    </p>
  </sect1>

  <sect1>
    <title>
      Working with countries &amp; territories
    </title>
    <p>
      TODO
    </p>
    <p>Example: drop-down select with territories</p>
    <p>Example: ecto validation function</p>
  </sect1>

  <sect1>
    <title>
      Handling currencies with ease
    </title>
    <p>
      TODO
    </p>
    <p>Example: drop-down select with currencies</p>
    <p>Example: ecto validation function</p>
    <p>Example: currency conversion?</p>
  </sect1>

  <sect1>
    <title>
      Supporting user locales / languages
    </title>
    <p>Example: locale-picker</p>
    <p>
      TODO
    </p>
  </sect1>

  <sect1>
    <title>
      Interpreting time-series data on different calendars
    </title>
    <p>
      TODO
    </p>
    <p>Example: find the start- and end dates for a quarter</p>
    <p>Example: American Retail Foundation's weekly calendar</p>
  </sect1>

  <sect1>
    <title>
      Converting between different measurement systems
    </title>
    <p>
      TODO
    </p>
    <p>Example: convert values from metric to imperial in vice versa</p>
  </sect1>

  <sect1>
    <title>
      In summary
    </title>
    <p> Now that we've seen how useful the <inlinecode>ex_cldr</inlinecode> suite of libraries can
      be for implementing application logic around standards-based entities like countries,
      currencies or languages, it's time to go a bit deeper on the topic of <emph>numbers</emph>
      specifically. In the next chapter we'll learn all about formatting numbers in ways that make
      them easily legible for our users. </p>
  </sect1>

</chapter>