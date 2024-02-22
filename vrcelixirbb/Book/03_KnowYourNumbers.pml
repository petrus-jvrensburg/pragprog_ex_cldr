<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.know_your_numbers">
<title>Know Your Numbers</title>
<storymap>
<markdown>
Why do I want to read this?
: Because numbers are where you'll get the most value off-the-bat when you add ex_cldr to your application.

What will I learn?
: You will learn the ropes when it comes to number formatting for different locales, including for ordinal values, phone numbers, currency values etc. You'll also get a sense for the different number systems that exist.

What will I be able to do that I couldn't do before?
: You'll be able to format numeric values in ways that boost the UX for your English users, but that can be extended for other locales with a simple configuration change. 

Where are we going next, and how does this fit in?
: Next, we'll look at the second-most common problem for internationalization, the one you'll likely have bumped into yourself: dates and times.
</markdown>
</storymap>

<sect1>
    <title>
    Introduction
    </title>
    <p>
        You may have found it frustrating at times, when software applications don't format 
        numbers consistently, making them hard to understand at a glance. For example,
        in an interface where you might be looking at important usage parameters, the 
        values <variable>1000000</variable> and <variable>10000000</variable> may be very difficult to tell apart, even though they
        differ by a very large amount... there's a whole order of magnitude between them!
    </p>

    <figure id="stats_before">
        <imagedata fileref="images/03_KnowYourNumbers/stats_before.png" align="center" width="90%" />
        <p>Usage statistics from an admin interface, without good number formatting.</p>
    </figure>

    <p>
        So in your own software, you might be tempted to write a quick function for adding 
        delimiters to numbers in order to display them as <variable>1,000,000</variable> or <variable>10,000,000</variable> 
        for example. And you would have done a good job at solving the problem for yourself.
        But a user from Brazil would have expected to see <variable>10.000.000</variable> and in 
        several European countries, they would have expected <variable>10 000 000</variable>, while in India
        the delimiter would be expected in a different place altogether, e.g. <variable>1,00,00,000</variable>. 
        We'll explain the reasons for this in the section on delimeters.
    </p>

    <p>
        In this chapter you'll learn how to 
        display numbers correctly for different audiences, 
        using the appropriate delimiters and decimals. The <inlinecode>ex_cldr_numbers</inlinecode> package
        makes this surprisingly simple.
    </p>

    <figure id="stats_after">
        <imagedata fileref="images/03_KnowYourNumbers/stats_after.png" align="center" width="90%" />
        <p>After adding delimiters and symbols in the appropriate places, the numbers are easier to interpret at a glance.</p>
    </figure>

    <p>
        We'll take a quick look at the underlying number systems themselves, and show how you 
        can convert between them when the context requires it. Then we'll show how to use the 
        <inlinecode>Cldr.Number.to_string/3</inlinecode> function for doing almost all the heavy lifting 
        when it comes to formatting the types of numbers that are commonly found in our user 
        interfaces. And we'll pay special attention to monetary values and phone numbers 
        specifically, for which we'll get some help from packages unrelated to the CLDR.
    </p>

    <p>
        Next we'll cover ordinal values (e.g. <variable>1st</variable>, <variable>2nd</variable> and <variable>3rd</variable>), Roman numerals and show 
        how you can spell-out numbers as words, like the ancient Greeks used to do before 
        they invented the Ionian number system.
    </p>

    <p>
        Finally, to make this even more useful, you'll learn how to use formatted numbers 
        in your markup. By wrapping the different parts of a number, like the numeric value 
        and the symbols around it, in your own code, you can style them individually like 
        we've done <xref linkend="stats_after">in this figure</xref>.
    </p>
</sect1>
</chapter>
