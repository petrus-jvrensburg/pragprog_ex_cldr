<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="chp.user_generated_content">
    <title>Translating User Generated Content</title>
    <storymap>
<markdown>
Why do I want to read this?
: If you're building an application where you have a bunch of records in a CMS, and
those are shown to users in different locales, the you want to read this to see how you
can do that without writing a whole bunch of custom appliction logic that's going to be
a pain to maintain.

What will I learn?
: You will learn how to use ex_cldr_translate to manage translations gracefully, on the
database.

What will I be able to do that I couldn't do before?
: You'll be able to add translation support for records in your backoffice / admin
interface with relative ease, and then expose those translated values to end-users via
the UI.

Where are we going next, and how does this fit in?
: Next we'll geek out on the really niche stuff, that's going to give you the edge in
your next performance review.
</markdown>
    </storymap>
    <sect1>
        <title>
            Introduction
        </title>
        <p>
            So far, we have been concerned with strings that live in a codebase: some
            of them are mostly static, and can be handled at compile-time using <inlinecode>gettext</inlinecode>.
            Others are variable, and for these we rely on <inlinecode>ex_cldr</inlinecode> at runtime.
            But when it comes to content from outside our codebase, we need a different
            approach.
        </p>
        <p>
            Whether you are displaying product information in a e-commerce application,
            or profile details
            in a two-sided marketplace, or even something as simple as a blog: the text
            content that a user
            can see is probably coming from a database. I.e. it doesn't live in the
            codebase of your application,
            and is therefore out-of-reach of gettext's extractor.
        </p>
        <p>
            Furthermore, there may be very many of these strings (it will scale with the
            number of records in
            your database), so the workflow that is used for managing gettext translations
            would quickly become
            unwieldy for this type of content.
        </p>
        <p>
            So, how should these strings be handled if we are to localize them for users
            in different locales?
        </p>
        <p>
            The most obvious way would be to store the translations together with the
            original strings themselves,
            in the database. But if you're not careful, this can introduce a lot of
            unneccessary complexity.
            To help address this problem, <inlinecode>ex_cldr_trans</inlinecode> exposes
            functionality for you to manage those translations effectively.
        </p>
    </sect1>

    <sect1>
        <title>
            Getting started
        </title>
        <p>TODO</p>
        <p>example: phoenix form for managing translations</p>
    </sect1>

    <sect1>
        <title>
            Under the hood
        </title>
        <p>TODO</p>
        <p>JSONB columns, but with some structure imposed.</p>
        <p>Postgres functions</p>
    </sect1>

    <sect1>
        <title>
            Using ex_cldr_trans with gettext
        </title>
        <p>TODO</p>
    </sect1>

    <sect1>
        <title>
            Translation via 3rd party APIs
        </title>
        <p>TODO</p>
        <p>example: pre-populate form fields with machine translations</p>
    </sect1>

    <sect1>
        <title>
            In summary
        </title>
        <p>
            In this chapter we learnt how to leverage the JSONB type in Postgres and machine
            translations to build a comprehensive backoffice service for managing translations
            in a database. For this we used a simple datamodel, where the translated content
            for a record is stored on the record itself, together with the source content.
        </p>
        <p>
            This can be useful for things like e-commerce applications, where you might want to
            present localized product information to your users. But the same approach could
            be useful in many other types of applications, like marketplaces for example.
        </p>
        <p>
            In previous chapters we learnt how to use <inlinecode>gettext</inlinecode> to translate static
            strings that live in our code, like the text on buttons or in navigation menus. Then
            we explored the use of the <inlinecode>ex_cldr</inlinecode> suite of packages for translating dynamic
            content: things like numbers, dates and units of measure, that typically pop up as
            variables in our code, and are therefore out of reach of <inlinecode>gettext</inlinecode>.
        </p>
        <p>
            Finally, after working through this chapter, you now have tools for translating
            content that lives in a database, bringing us full-circle.
        </p>
    </sect1>
</chapter>