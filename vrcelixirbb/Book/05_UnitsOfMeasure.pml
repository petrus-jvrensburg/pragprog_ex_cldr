<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.units_of_measure">
    <title>Units of Measure</title>
    <storymap>
<markdown>
Why do I want to read this?
: As a user, you will have experienced mix-ups around metric vs imperial. Or as an
application developer, you will have coded-up some spaghetti for handling unit
conversions and
formatting conventions. You're reading this because you've been bitten by it before.

What will I learn?
: You will learn that there is a better way to do things than you have encountered
previously. It uses a standards-based approach to keep things sane and pushes some logic
down to
the database, so you doon't have to handle it in your application code.

What will I be able to do that I couldn't do before?
: Validate units, convert between them and display them appropriately. First for your
English users, and then for other locales with a simple configuration change.

Where are we going next, and how does this fit in?
: This was a somewhat niche application. Next we're looking at managing translations for
records in your database in a way that keeps the complexity to an absolute minimum.
</markdown>
    </storymap>

    <sect1>
        <title>
            Introduction
        </title>
        <p> The CLDR defines some of the ideosyncratic ways in which units are formatted for
            different locales. For example, in English one might talk about <inlinecode>10 feet</inlinecode>,
            while in Japanese that would be <inlinecode>10 フィート</inlinecode> or <inlinecode>10 Fuß</inlinecode>
            in German. <inlinecode>ex_cldr</inlinecode> is smart enough to know the correct
            translation for units like these, and even smart enough to know when to use a plural or
            singular form: </p>

        <code language="iex">
            > Cldr.Unit.to_string!(1, unit: :foot, locale: "en")

            "1 foot"

            > Cldr.Unit.to_string!(10, unit: :foot, locale: "en")

            "10 feet"
        </code>

        <p>
            But the CLDR also knows which measuring systems are used in the different locales,
            so we can use it to convert a unit into the appropriate unit for the user's locale:
        </p>

        <code language="iex">
            > Cldr.Unit.new!(10, :foot)
            |> Cldr.Unit.localize(locale: "de")
            |> Cldr.to_string()

            "3.048 meters"
        </code>

        <p> In this chapter, we'll explore the types of units that the CLDR can help us with, and
            learn how they can be formatted for different contexts and different locales. Then we'll
            go a step furhter to explore how the <inlinecode>ex_cldr_units</inlinecode> package can
            be used for converting between units, persisting them consistently in a database and
            performing arithmetic on them when needed. </p>

        <!-- <p>
            But where might this be useful?
    
            * property listings (square meters)
            
            * distance travelled (miles vs kilometers)
            
            * energy usage tracking (Joules, Watts etc.)
            
            * scientific applications (SI units)
            
            * Entity-Attribute-Value data models, like you might see in e-commerce (ref Dimitri 
            Fontaine's advice on avoiding this model if possible)
            
            Stories that can bring it together
            
            * Why we have sixty seconds in a minute, and sixty minutes in an hour.
            
            * Gallon vs Imperial Gallon
            
            * Metric system history
        </p> -->
    </sect1>

    <sect1>
        <title>
            Getting started
        </title>
        <p> TODO <!-- Which units are available?
    
    Overall approach: Cldr.Unit.new() -> Cldr.Unit.localize(usage: usage) -> Cldr.to\_string()
    
    Note: dependency on Cldr.Lists for formatting after calling localize().
    
    What is a "usage"? Which usages are available?
    
    Cldr.Unit.preferred\_units(), available mappings per context
    
    Formatting examples -->
        </p>
    </sect1>

    <sect1>
        <title>
            Working with measurement systems
        </title>
        <p>TODO</p>
        <!-- As part of a user's locale, a measurement system may be specified. But even if it's
        not,
    one will be implied, depending on the root locale. In the CLDR there are three different 
    measurement systems defined: \mintinline{latex}!:metric!, which is used most widely, and two
        flavours
    the old Imperial system namely \mintinline{latex}!:ussystem! and \mintinline{latex}!:uksystem!. -->
    </sect1>

    <sect1>
        <title>
            Working with units
        </title>
        <p>TODO</p>
        <!-- <p>
            * person height
    
            * distance
        </p> -->
    </sect1>

    <sect1>
        <title>
            Persisting units to a database
        </title>
        <p>TODO</p>
        <!-- <p>
            * Naive approach
    
            * Cldr.Unit.Sql approach 
            
            trade-offs / advantages (e.g. difficulty with aggregation \& sorting)
            
        </p> -->
    </sect1>

    <sect1>
        <title>
            Unit de-composition
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>
            Selecting units from a dropdown
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>In summary</title>
        <p>
            In this chapter we learnt how to work with units, not just for formatting them
            consistently, but also for converting between them, doing arithmetic on compatible units
            and persisting them to a database.
        </p>

        <p> There are lots of units defined in the CLDR, which also defines which categories those
            units fall into and how conversion between units should work. But if your application
            uses units that are not defined in the CLDR, <inlinecode>ex_cldr_units</inlinecode>
            let's you define your own. We'll see that in the next chapter. </p>
    </sect1>


</chapter>