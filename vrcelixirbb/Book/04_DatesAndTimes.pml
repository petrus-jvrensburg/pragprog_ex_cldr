<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.dates_and_times">
    <title>Formatting Dates &amp; Times</title>
    <storymap>
<markdown>
Why do I want to read this?
: You've probably bumped into this problem yourself before, and have solved it with
if-statements, head-scratching and frustration.

What will I learn?
: You will learn about the conventions around date and time formatting, and about the
different calendar systems that exists, and how they can be used in your code.

What will I be able to do that I couldn't do before?
: You'll be able to format dates and times consistently, first to improve UX for English
users, and then for other locales with a simple configuration change. And you'll be able
to convert between calendars.

Where are we going next, and how does this fit in?
: This wraps up the most common use-cases, and you can stop reading here, or scan the
next few chapters to get an idea for what other niche problems these libraries can solve
for you.
</markdown>
    </storymap>

    <sect1>
        <title>
            Introduction
        </title>
        <p> Building on our ability to handle numbers, we'll focus here on the tricky topic of date
            and time formatting. In this chapter you'll see how to programatically generate strings
            like <inlinecode>"12/21/85"</inlinecode> or <inlinecode>"21 Dec 1985"</inlinecode> or
            even <inlinecode>"tomorrow"</inlinecode> and <inlinecode>"5 minutes ago"</inlinecode>. </p>

        <p> With the help of CLDR, the same logic that gives us the string <inlinecode>"12/21/85"</inlinecode>
            for an English user in the US can also give us <inlinecode>"21/12/85"</inlinecode> in
            Hindi and <inlinecode>"21/12/1985"</inlinecode> in Portuguese, without us having to do
            any extra work. </p>

        <p>
            At the end of the chapter, we'll go a little deeper to show how simple it is to support
            alternative calendars in your code, though you can gladly skip that section if your
            target audience is is limited to territories that use the Gregorian calendar.
        </p>

        <p>TODO - Where does this fit in?</p>
        <p>Timex? Standard library datetime formatting? How does this compare?</p>
    </sect1>

    <sect1>
        <title>
            Builtin date-time formats
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>
            Custom format specifiers
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>
            Relative times and durations
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>
            Switching between calendars
        </title>
        <p>TODO</p>
        <!-- * financial
    
        * regional
        
        * historical -->
    </sect1>

    <sect1>
        <title>In summary</title>
        <p> We saw in this chapter how simple it can be to format dates, times and durations
            consistently with the help of <inlinecode>ex_cldr_dates_times</inlinecode>. Things have
            gotten a bit more technical, and it will continue along that trend as we explore the
            CLDR's use of different measuring systems in the next chapter. </p>

        <p> If the builtin calendars don't satisfy your needs, you can define your own using <inlinecode>
            ex_cldr_calendars</inlinecode>. We didn't cover those here, but we'll have alook at them
            in <xref linkend="chp.advanced">in the final chapter</xref>. This could be useful for
            example if you have a custom fiscal calendar that you'd like to work with. </p>
    </sect1>
</chapter>