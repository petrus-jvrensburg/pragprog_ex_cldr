# -*- coding: utf-8 -*-
require "kramdown"
require "rexml/parsers/baseparser"

module Kramdown

  # Ugly, but we need to allow periods in ids...
  module Parser
    class Kramdown
      v = $VERBOSE
      $VERBOSE = nil
      HEADER_ID = /(?:[ \t]\{#(\w[-.\w]*)\})?/
      SETEXT_HEADER_START = /^(#{OPT_SPACE}[^ \t].*?)#{HEADER_ID}[ \t]*?\n(-|=)+\s*?\n/
      ATX_HEADER_MATCH = /^(\#{1,6})(.+?)\s*?#*#{HEADER_ID}\s*?\n/
      $VERBOSE = v
    end
  end

  # Build the list of tags that are allowed in spans. If we don't do this, then if such a
  # tag starts a line, it will force a new paragraph

  module Parser
    class Html
      module Constants
        HTML_ELEMENTS_WITHOUT_BODY.delete "col"
        HTML_BLOCK_ELEMENTS.delete "col"
        HTML_BLOCK_ELEMENTS.delete "table"

        HTML_CONTENT_MODEL["if"] = :raw

        dtd_name = File.expand_path("../../../xml/ppbook.dtd", File.dirname(__FILE__))

        if File.exist?(dtd_name)
          dtd = File.read(dtd_name)
          def dtd.get_elements(name)
            unless self =~ /<!ENTITY\s+%\s+#{name}(.*?)>/m
              STDERR.puts "Can't find DTD entity #{name}"
              []
            else
              $1.scan(/\|\s+(\w+)/).flatten
            end
          end
          keys = dtd.get_elements("mac.keys")
          rest = dtd.get_elements("char.flow")
          HTML_SPAN_ELEMENTS.replace(keys + rest)
          HTML_SPAN_ELEMENTS.push "if"
        else
          STDERR.puts "WARNING: can't find dtd in #{dtd_name}"
        end
      end
    end
  end

  module Converter
    class Pml < Base
      include ::Kramdown::Utils::Html

      # The amount of indentation used when nesting HTML tags.
      attr_accessor :indent

      # Initialize the HTML converter with the given Kramdown document +doc+.
      def initialize(root, options)
        super
        @indent = 2
        @stack = []
        @use_rouge = options[:use_rouge]
      end

      # The mapping of element type to conversion method.
      DISPATCHER = Hash.new { |h, k| h[k] = "convert_#{k}" }

      # Dispatch the conversion of the element +el+ to a
      # +convert_TYPE+ method using the +type+ of the element.
      def convert(el, indent = -@indent)
        @lowest_section_number = nil

        [
          send(DISPATCHER[el.type], el, indent),
          close_sections_up_to(@lowest_section_number || 0),
        ].join
      end

      # Return the converted content of the children of +el+ as a
      # string. The parameter +indent+ has to be the amount of
      # indentation used for the element +el+.
      #
      # Pushes +el+ onto the @stack before converting the child
      # elements and pops it from the stack afterwards.
      def inner(el, indent)
        result = []
        indent += @indent
        @stack.push(el)
        el.children.each do |inner_el|
          result << send(DISPATCHER[inner_el.type], inner_el, indent)
        end
        @stack.pop
        result.join
      end

      def convert_blank(el, indent)
        "\n"
      end

      def convert_text(el, indent)
        escape_html(el.value, :text)
      end

      def convert_p(el, indent)
        unless el.children.empty?
          child = el.children.first
          type = child.type
          element_name = child.value if (child.type == :html_element)
        end

        if type == :img || (type == :html_element && element_name == "if")
          inner(el, indent)
        else
          "#{" " * indent}<p#{html_attributes(el.attr)}>#{inner(el, indent)}</p>\n"
        end
      end

      def convert_em(el, indent)
        "<emph#{html_attributes(el.attr)}>#{inner(el, indent)}</emph>"
      end

      def convert_strong(el, indent)
        "<emph#{html_attributes(el.attr)}>#{inner(el, indent)}</emph>"
      end

      SECTION_NAME = %w{
        nil, chapter sect1 sect2 sect3 sect4
      }

      def convert_header(el, indent)
        level = el.options[:level].to_i
        result = []
        closings = close_sections_up_to(level - 1)
        @level = level
        if @lowest_section_number.nil? || @lowest_section_number >= @level
          @lowest_section_number = @level - 1
        end
        result << closings if closings.length > 0
        result << "#{"  " * indent}<#{SECTION_NAME[level]}#{html_attributes(el.attr)}>"
        result << "#{"  " * (indent + 1)}<title>#{inner(el, indent)}</title>"
        result.join("\n")
      end

      def close_sections_up_to(level)
        result = []
        unless @level.nil?
          while @level > level
            result << "</#{SECTION_NAME[@level]}>"
            @level -= 1
          end
        end
        @level = level
        result.join("\n")
      end

      def convert_footnote(el, indent)
        ["<footnote>\n", inner(el.value, 0), "</footnote>"].join
      end

      def convert_codeblock(el, indent)
        res = [
          "<code#{html_attributes(el.attr)}>\n",
          "<![CDATA[\n",
          el.value,
          "]]>\n",
          "</code>\n",
        ].join
      end

      def convert_blockquote(el, indent)
        "#{" " * indent}<blockquote#{html_attributes(el.attr)}>\n#{inner(el, indent)}#{" " * indent}</blockquote>\n"
      end

      def convert_hr(el, indent)
        #        "#{' '*indent}<hr />\n"
        fatal("We don't support horizontal rules in Markdown")
      end

      def du(el, indent = 0)
        STDERR.puts "#{" " * indent}#{el.type}: #{el.value}"
        el.children.each do |ch|
          du(ch, indent + 5)
        end
      end

      # a single level list where every child is a li containing a single
      # p[@transparent=true] is compact

      def convert_ul(el, indent)
        # du(el)
        return "" if el.children.empty?
        first_item = el.children.first
        item_type = first_item.type

        unless item_type == :li || item_type == :dt
          fatal("Expecting a list to start with a line item (not #{item_type})")
        end

        return "" if first_item.children.empty?

        compact = true
        el.children.each do |li|
          first = li.children.first
          if li.children.size > 1 || first.type != :p || !first.options[:transparent]
            compact = false
            break
          end
        end

        attr = el.attr.dup
        if compact
          attr["style"] = "compact"
        end
        "#{" " * indent}<#{el.type}#{html_attributes(attr)}>\n#{inner(el, indent)}#{" " * indent}</#{el.type}>\n"
      end

      alias :convert_ol :convert_ul
      alias :convert_dl :convert_ul

      def convert_li(el, indent)
        output = " " * indent << "<#{el.type}" << html_attributes(el.attr) << ">\n"
        output << inner(el, indent)
        output << " " * indent << "</#{el.type}>\n"
      end

      alias :convert_dd :convert_li

      def convert_dt(el, indent)
        %{#{" " * indent}<dt newline="yes"#{html_attributes(el.attr)}>#{inner(el, indent)}</dt>\n}
      end

      # A list of all HTML tags that need to have a body (even if the body is empty).
      HTML_TAGS_WITH_BODY = ["div", "span", "script", "iframe", "textarea", "a"] # :nodoc:

      def convert_html_element(el, indent)
        output = []
        tag = el.value
        tag = "code" if tag == "embed"

        # <extract> cannot occur in sect2's, so we close them off first
        # DT: comment out 8/19/13
        #if tag == 'extract' && @level > 1
        #  output << close_sections_up_to(1) << "\n"
        #end

        res = inner(el, indent)
        if el.options[:category] == :span
          output <<
            "<#{tag}#{html_attributes(el.attr)}" <<
            (!res.empty? || HTML_TAGS_WITH_BODY.include?(tag) ? ">#{res}</#{tag}>" : " />")
        else
          output << " " * indent if @stack.last.type != :html_element || @stack.last.options[:content_model] != :raw
          output << "<#{tag}#{html_attributes(el.attr)}"
          if !res.empty? && el.options[:content_model] != :block
            output << ">#{res}</#{tag}>"
          elsif !res.empty?
            output << ">\n#{res.chomp}\n" << " " * indent << "</#{tag}>"
          elsif HTML_TAGS_WITH_BODY.include?(tag)
            output << "></#{tag}>"
          else
            output << " />"
          end
          output << "\n" if @stack.last.type != :html_element || @stack.last.options[:content_model] != :raw
        end
        output.join
      end

      def convert_xml_comment(el, indent)
        if el.options[:category] == :block && (@stack.last.type != :html_element || @stack.last.options[:content_model] != :raw)
          " " * indent << el.value << "\n"
        else
          el.value
        end
      end

      alias :convert_xml_pi :convert_xml_comment

      def convert_table(el, indent)
        result = [" " * indent, "<table#{html_attributes(el.attr)}>\n"]
        if alignment = el.options[:alignment]
          alignment.each_with_index do |align, col|
            next if align == :default
            result << " " * (indent + 1)
            result << %{<colspec col="#{col + 1}" align="#{align}"/>\n}
          end
        end
        result << inner(el, indent)
        result << " " * indent << "</table>\n"
        result.join
      end

      def convert_thead(el, indent)
        result = [" " * indent, "<thead#{html_attributes(el.attr)}>\n"]
        el.children.each do |inner_el|
          result << inner(inner_el, indent)
        end
        result << " " * indent << "</thead>\n"
        result.join
      end

      def convert_tr(el, indent)
        "#{" " * indent}<row#{html_attributes(el.attr)}>\n#{inner(el, indent)}#{" " * indent}</row>\n"
      end

      def convert_tbody(el, indent)
        inner(el, indent)
      end

      alias :convert_tfoot :convert_tbody

      ENTITY_NBSP = ::Kramdown::Utils::Entities.entity("nbsp") # :nodoc:

      def convert_td(el, indent)
        res = inner(el, indent)
        type = :col
        attr = el.attr
        res = "<p>#{res}</p>"
        "#{" " * indent}<#{type}#{html_attributes(attr)}>#{res.empty? ? entity_to_str(ENTITY_NBSP) : res}</#{type}>\n"
      end

      def convert_comment(el, indent)
        if el.options[:category] == :block
          "#{" " * indent}<!-- #{el.value} -->\n"
        else
          "<!-- #{el.value} -->"
        end
      end

      def convert_br(el, indent)
        "<newline />"
      end

      def convert_a(el, indent)
        res = inner(el, indent)
        attr = el.attr.dup
        href = attr["href"] or fatal("Missing href for link: #{el.inspect}")
        if href[0] == ?#
          %{<ref linkend="#{href[1..-1]}"/>}
        else
          if href == res
            "<url>#{href}</url>"
          else
            %{#{res}<footnote><p><url>#{href}</url></p></footnote>}
          end
        end
      end

      def convert_img(el, indent)
        attr = Marshal.load(Marshal.dump(el.attr))
        attr["fileref"] = attr.delete("src")
        attr.delete("alt")
        "<imagedata#{html_attributes(attr)} />"
      end

      def convert_codespan(el, indent)
        "<ic#{html_attributes(el.attr)}>#{escape_html(el.value)}</ic>"
      end

      def convert_raw(el, indent)
        if !el.options[:type] || el.options[:type].empty? || el.options[:type].include?("html")
          el.value + (el.options[:category] == :block ? "\n" : "")
        else
          ""
        end
      end

      def convert_entity(el, indent)
        entity_to_str(el.value, el.options[:original])
      end

      TYPOGRAPHIC_SYMS = {
        :mdash => [::Kramdown::Utils::Entities.entity("mdash")],
        :ndash => [::Kramdown::Utils::Entities.entity("ndash")],
        :hellip => [::Kramdown::Utils::Entities.entity("hellip")],
        :laquo_space => [::Kramdown::Utils::Entities.entity("laquo"), ::Kramdown::Utils::Entities.entity("nbsp")],
        :raquo_space => [::Kramdown::Utils::Entities.entity("nbsp"), ::Kramdown::Utils::Entities.entity("raquo")],
        :laquo => [::Kramdown::Utils::Entities.entity("laquo")],
        :raquo => [::Kramdown::Utils::Entities.entity("raquo")],
      } # :nodoc:

      def convert_typographic_sym(el, indent)
        TYPOGRAPHIC_SYMS[el.value].map { |e| entity_to_str(e) }.join("")
      end

      SMART_QUOTES = {:lsquo => "‘", :rsquo => "’", :ldquo => "“", :rdquo => "”"}

      # override build in, because our xml doesn't know the entity names
      def convert_smart_quote(el, indent)
        SMART_QUOTES[el.value]
      end

      def convert_math(el, indent)
        block = (el.options[:category] == :block)
        value = (el.value =~ /<|&/ ? "% <![CDATA[\n#{el.value} %]]>" : el.value)
        "<script type=\"math/tex#{block ? "; mode=display" : ""}\">#{value}</script>#{block ? "\n" : ""}"
      end

      def convert_abbreviation(el, indent)
        title = @root.options[:abbrev_defs][el.value]
        "<abbr#{!title.empty? ? " title=\"#{title}\"" : ""}>#{el.value}</abbr>"
      end

      def convert_root(el, indent)
        inner(el, indent)
      end

      def fatal(msg)
        STDERR.puts "Conversion from Markdown to PML failed:\n\t#{msg}"
        exit(1)
      end
    end
  end
end
