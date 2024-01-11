# THIS IS A HACK just to see if stuff works on the Kindle


EBOOK_SUPPORT = File.expand_path("..", File.dirname(__FILE__))

require 'rubygems'  
require 'RMagick'    
require 'stringio'
require 'yaml'

if ENV['EMBED_SKIP_LEADING']
  SKIP_LEADING = Regexp.new("^" + ENV['EMBED_SKIP_LEADING'])
else
  SKIP_LEADING = nil
end


# Valid arguments to a <code> element, and their default values
DEFAULT_ARGS = {
  'file' => nil,                 # name of file to read from
  'part' => nil,                 # which part of file to read
  'language' => nil,             # determine the code fragment's language
  'forcenumber'   => "no",       # do we number lines  (NOT TO BE USED BY AUTHORS)
  'indent'   => "no",            # do we indent lines
  'verbatim' => "no",            # don't strip START: and END: comments,
                                 # and don't honor <label>
  'showname' => nil,             # show the filename in the margin
  'display'  => "no",            # use display format: smaller font, inline name
  'size'     => "normal",        # 'small' uses a smaller size instead of footnotesize
  'id'       => nil,
  'crossref' => 'yes',           # do we honor <label> Turn off if
                                 # you embed the same file more than once
  'highlight' => 'yes',          # do we honor START_HIGHLIGHT
 'livecode' => 'yes',           # ta with livecode numbers
  'style'    => 'normal',        # 'compact' reduces line spacing

  'cite'        => nil,             # cite the source

  # regexp-based inclusion
  'start'       => nil,          # pattern to start matching
  'end'         => nil,          # where to end
  'end-exclude' => nil,          # where to end (but exclude that line)

}

# Look for a local "emedcode.rc" file and use it to override options
DEFAULT_ARGS.merge!(YAML.load_file("embedcode.rc")) rescue 1
#STDERR.puts DEFAULT_ARGS.inspect


class CODE_XREF

  def self.dump_xrefs(xrefs)
    puts "<livecodelist>"
    xrefs.keys.sort.each do |filename|
      puts %{  <lclentry name="#{filename}" ref="#{xrefs[filename]}"/>}
    end
    puts "</livecodelist>"
  end

  def self.map_xrefs(content)

    xrefs = {}
    content.scan(%r{<processedcode(.*?)>}) do |args,|
      if args !~ /livecode="no"/  && args =~ /file="(.*?)"/
        xrefs[$1] = 1
      end
    end

    count = 1
    xrefs.keys.sort.each do |filename|
      xrefs[filename] = count
      count += 1
    end
    
    content.each_line do |line|
      case line
      when %r{<processedcode[^>]*?file="(.*?)"}
        filename = $1
        if line =~ /livecode="(.*?)"/
          if $1 == "no"
            puts line.sub(/livecode=".*?"/, '')
          else
            puts line.sub(/livecode=".*?"/) { %{livecode="#{xrefs[filename]}"} }
          end
        else
          puts line
        end

      when %r{<dumplivecode/>}
        dump_xrefs(xrefs)
        
      else
        puts line
      end
    end
  end

end


#
# Descriptions of the highlighting rules
#

class Formatters

  Description = Struct.new(:comment, :callout, :wtf, :string, :keyword, :attribute, :prompt)

  def initialize
    @formatters = {}
  end

  VALID_OPTION = {
    :comment    => 1, :string => 1, :keywords => 1, :extra_keywords => 1,
    :attributes => 1, :prompt => 1, :aka      => 1, :label_regexp   => 1,
    :callout    => 1, :wtf    => 1
  }

  def for(language, options)

    options.each do |opt, value|

      fail "Invalid option #{opt} for #{language}" unless VALID_OPTION[opt]
    end

    desc = Description.new

    fail("missing comment for #{language}") unless options[:comment]
    desc.comment = Regexp.new(options[:comment])

    fail("missing string for #{language}") unless options[:string]
    desc.string  = Regexp.new(options[:string]) 

    keywords = nil
    if options[:keywords]
      keywords = '\b(' + options[:keywords].join("|") + ')\b'
    end

    if options[:extra_keywords]
      keywords ||= ""
      keywords << "|" << options[:extra_keywords]
    end

    desc.keyword   = Regexp.new(keywords) if keywords

    desc.attribute = Regexp.new(options[:attributes]) if options[:attributes]
    desc.prompt    = Regexp.new(options[:prompt])     if options[:prompt]

    desc.callout = options[:callout]
    desc.wtf     = options[:wtf]

    @formatters[language] = desc

    if options[:aka]
      options[:aka].each do |aka|
        @formatters[aka] = desc
      end
    end
  end

  def [](language)
    @formatters[language]
  end
end


FORMATTERS = Formatters.new

CO = %{\\s*<(label|callout)\s+id=".*?"\s*/>\\s*}

C_CALLOUT      = %r{/\*#{CO}\*/|//#{CO}}o
PHP_CALLOUT    = %r{\##{CO}|//#{CO}}o
SCRIPT_CALLOUT = %r{\##{CO}}o

STD_STRING     = "('|\")(?:|.*?[^\\\\])\\1"

FORMATTERS.for('antlr',
               :comment => '(?:/\*(?:.|\n)*?\*/)|//.*',
               :callout => C_CALLOUT,
               :string  => "(').*?\\1",
               :aka     => %w{ g },
               :keywords => 
                  %w{ protected public private fragment returns init header 
		      parser lexer tree grammar tokens options EOF scope 
		      throws exception catch})


FORMATTERS.for('m',
               :aka     => %w{ objc },
               :comment => '(?:/\*(?:.|\n)*?\*/)|//.*|Statement',
               :string  => '".*?"',
               :callout => C_CALLOUT,
               :keywords => 
                   %w{ 
                        __asm __attribute__ __based __cdecl
                        __cplusplus __emit __export __far __fastcall __fortran __huge __inline
                        __interrupt __loadds __multiple_inheritance __near __pascal __saveregs
                        __segment __segname __self __single_inheritance __stdcall __syscall
                        __virtual_inheritance argc argv auto bool break bycopy byref case
                        catch char class const const_cast continue default delete do double
                        dynamic_cast else enum envp explicit extern false float for friend goto id
                        if in inline inout int long main mutable namespace new operator out
                        private protected public register reinterpret_cast return self short
                        signed sizeof static static_cast struct super switch template this
                        throw true try typedef typeid typename union unsigned using virtual
                        void volatile wchar_t while wmain
                      },
                :extra_keywords =>
                    '((^\#\s*(define|elif|else|endif|error|if|ifdef|ifndef|import|include|line|pragma|undef))'+
                    '|' +
                    '(@(catch|class|encode|end|finally|implementation|interface|optional|private|property|protected|protocol|public|required|selector|synchronize|throw|try)))')
                       
FORMATTERS.for('c',
               :aka     => %w{ cpp },
               :comment => '(?:/\*(?:.|\n)*?\*/)|//.*',
               :string  => '".*?"',
               :callout => C_CALLOUT,
               :keywords => 
                   %w{ asm auto bool break case char class
                       continue default do double else enum
                       extern float for fortran goto 
           	       if int long register return short sizeof static
		       struct switch typedef union unsigned while void 
		       class const delete friend inline new operator 
                       overload private protected public virtual},
                :extra_keywords =>
                    '(^\#\s*(define|else|endif|ifdef|if|ifndef|include|undef))')

FORMATTERS.for('clj',
             :aka     => %w{ clojure },
             :comment => ';.*',
             :callout =>  %r{;#{CO}}o,
             :string  => STD_STRING,
             :keywords =>
              %w{ cond for loop let recur do binding with-meta
                when when-not when-let when-first if if-let
                delay lazy-cons and or locking
                dosync
                sync doseq dotimes import unimport in-ns refer
                implement proxy time try catch finally throw
                doto with-open with-local-vars struct-map
               })


FORMATTERS.for('conf',
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
               :string  => STD_STRING,
#               :string  =>"('|\").*?\\1",
               :extra_keywords => '(\[.*?\])')
                       

FORMATTERS.for('css',
               :comment        => "/\*(?:.|\n)*?\*/",
               :callout        => %r{/\*#{CO}\*/},
               :string         => "\#[0-9a-f]+",
               :extra_keywords => '^(.*)\{',
               :attributes     =>'^\s*([-\w]+):\s')
                       
                       
FORMATTERS.for('erlang',
               :aka     => %w{ erl },
               :comment => '%.*',
               :callout => %r{%%#{CO}},
               :string => '".*?"',
               :keywords => %w{ try catch after begin behaviour if case end receive fun of },
               :extra_keywords => "-(module|import|export|record|macro|define|compile)")

FORMATTERS.for('ghci',
               :comment => '--.*',
               :callout => SCRIPT_CALLOUT,
               :string  => "impossible string....",
               :prompt  => '^([^\n\-><]*>)(.*)')
               
FORMATTERS.for('groovy',
               :comment => '(#|//).*',
               :callout =>  C_CALLOUT,
               :string  => STD_STRING,
#               :string => "('|\").*?\\1",
               :keywords => %w{
                     abstract as assert boolean break byte case catch
                     char class const continue def default do double
                     else extends false final finally float for goto
                     if implements import instanceof int interface
                     long native new null package print println
                     private property protected public return short
                     static super switch synchronized this throw
                     throws true try void while})
          

FORMATTERS.for('haskell',
               :aka      => %w{ hs lhs },
               :comment  => '(?:\{-(?:.|\n)*?-\})|--.*',
               :string   => STD_STRING,
               :keywords => %w{
                 as case class data default deriving do else error hiding
                 if import in infix infixl infixr instance let module newtype
                 of qualified then trace type undefined where
               })

                                           
# irb is like session, but the prompt is 'irb.*>'

FORMATTERS.for('irb',
               :comment => '#(?!\d).*',
               :callout => SCRIPT_CALLOUT,
               :string  => 'xxxyyyxxxyyyxxx',
               :prompt  => '^(irb.*?>)(.*)')
     
FORMATTERS.for('repl',
               :comment => '#(?!\d).*',
               :callout => SCRIPT_CALLOUT,
               :string  => 'xxxyyyxxxyyyxxx',
               :prompt  => '^(->.*|user=>|)(.*)')

                  
FORMATTERS.for('java',
               :comment => '(?:/\*(?:.|\n)*?\*/)|//.*',
               :callout => C_CALLOUT,
               :string  => STD_STRING,
#               :string  => "('|\").*?\\1",
               :keywords => 
                  %w{abstract boolean break byte byvalue
	             case cast catch char class const
		     continue do double else extends
		     false final finally float for future
                     generic goto if implements import
                     instanceof int interface long native
                     new null package private protected
                     public return short static super
                     switch synchronized this throws
                     transient true try void volatile while})

FORMATTERS.for('javascript',
               :aka     => %w{ js jscript },
               :comment => '(?:/\*(?:.|\n)*?\*/)|//.*',
               :callout => C_CALLOUT,
               :string  => STD_STRING,
#               :string  =>"('|\").*?\\1",
               :keywords => 
                  %w{abstract   extends     int        super
                     boolean    false       interface  switch
                     break      final       long       synchronized
                     byte       finally     native     this
                     case       float       new        throw
                     catch      for         null       throws
                     char       function    package    transient
                     class      goto        private    true
                     const      if          protected  try
                     continue   implements  public     var
                     default    import      return     val
                     do         in          short      while
                     double     instanceof  static     with
                     else})

FORMATTERS.for('makefile',
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
               :string  => STD_STRING,
#               :string  =>"('|\").*?\\1",
               :extra_keywords => '^([\w\d.-_]+):')
                       

 # Nullsoft installer
FORMATTERS.for('nsi',
               :comment => ';.*',
               :callout => %r{;#{CO}},
               :string  => STD_STRING,
#               :string  => "('|\").*?\\1",
               :keywords => 
                %w{ !define !include !insertmacro
                    Call CreateDirectory CreateShortCut DeleteRegKey
                    DetailPrint File FileClose FileOpen FileWrite
                    Function FunctionEnd Name InstallDir OutFile
                    Page RMDir Section SectionEnd SetOutPath  
                    Setoverwrite ShowInstDetails ShowUninstDetails 
                    VAR WriteRegStr WriteUninstaller })

FORMATTERS.for('pl',
               :aka     => %w{ perl },
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
#                  %q{'.*?'|".*?"|qw\((.|\n)*?\)},
               :string => %{(['"`]).*?\\1}, #`"'
               :keywords =>
                  %w{AUTOLOAD BEGIN CORE DESTROY END __END__
		    __FILE__ __LINE__ abs accept alarm and
		    atan2 bind binmode bless caller chdir
		    chmod chomp chop chown chr chroot close
		    closedir cmp connect continue cos crypt
		    dbmclose dbmopen defined delete die do
		    do dump each else else elsif elsif
		    endgrent endhostent endnetent
		    endprotoent endpwent endservent eof eq
		    eval exec exists exit exp fcntl fileno
		    flock for for foreach fork format
		    formline ge getc getgrent getgrgid
		    getgrnam gethostbyaddr gethostbyname
		    gethostent getlogin getnetbyaddr
		    getnetbyname getnetent getpeername
		    getpgrp getppid getpriority
		    getprotobyname getprotobynumber
		    getprotoent getpwent getpwnam getpwuid
		    getservbyname getservbyport getservent
		    getsockname getsockopt glob gmtime goto
		    grep gt hex if index int ioctl join keys
		    kill last lc lcfirst le length link
		    listen local localtime log lstat lt m
		    map mkdir msgctl msgget msgrcv msgsnd my
		    ne next no not oct open opendir or ord
		    pack package pipe pop pos print printf
		    push q qq quotemeta qw qx rand read
		    readdir readline readlink readpipe recv
		    redo redo ref rename require reset
		    return reverse rewinddir rindex rmdir s
		    scalar seek seekdir select semctl semget
		    semop send setgrent sethostent setnetent
		    setpgrp setpriority setprotoent setpwent
		    setservent setsockopt shift shmctl
		    shmget shmread shmwrite shutdown sin
		    sleep socket socketpair sort splice
		    split sprintf sqrt srand stat study sub
		    substr symlink syscall sysread system
		    syswrite tell telldir tie time times tr
		    truncate uc ucfirst umask undef unless
		    unlink unpack unshift untie until use
		    use utime values vec wait waitpid
		    wantarray warn while write x xor y},
                  :extra_keywords =>
                    '(^\#\s*(define|else|endif|if|ifdef|ifndef|include|undef))')


FORMATTERS.for('php',
               :aka     => %w{ PHP },
               :comment => "#.*",
               :callout => PHP_CALLOUT,
               :string  => %{"""(.|\n)+?"""|'.*?'},  #"
               :keywords =>
                       %w(
                          and     or      xor     __FILE__        exception
                         __LINE__ array   as      break   case
                         class   const   continue        declare default
                         die   do      echo  else    elseif
                         empty enddeclare      endfor  endforeach      endif
                         endswitch       endwhile        eval  exit  extends
                         for     foreach function        global  if
                         include       include_once  isset list  new
                         print require       require_once  return        static
                         switch  unset  use    var     while
                         __FUNCTION__ __CLASS__ __METHOD__
                         final   php_user_filter
                         interface implements extends public  private protected
                         abstract        clone  try     catch
                         throw   cfunction       old_function))


FORMATTERS.for('py',
               :aka     => %w{ python },
               :comment => "#.*",
               :callout => SCRIPT_CALLOUT,
               :string  => %{"""(.|\n)+?"""|'.*?'},  #"
               :keywords =>
                       %w(access continue else for import not raise
                       and def except from in or return
                       break del exec global is pass try
                       class elif finally if lambda print while))

_ruby_opts = {
  :aka     => %w{ ruby rxml rjs },
  :comment => '#.*',
  :callout => SCRIPT_CALLOUT,
  :wtf     => %r{\#\s*(<wtf\s+linkend=".*?">.*?</wtf>)\s*},
  :string  => STD_STRING,
  :keywords => 
    %w{ BEGIN END alias and begin break case 
        class def defined?  do else elsif
        end ensure false for if in module 
        next nil not or redo require require_gem rescue retry
        return self super then true undef
        unless until when while yield }
               }

FORMATTERS.for('rb', _ruby_opts)

_rspec_opts = _ruby_opts.dup
_rspec_opts.delete(:aka)
_rspec_opts[:keywords].concat %w{
     context describe example it share_as shared_examples_for
     simple_matcher specify
}
FORMATTERS.for('rspec', _rspec_opts)


FORMATTERS.for('scala',
               :comment => '(#|//).*',
               :callout =>  C_CALLOUT,
               :string  => STD_STRING,
               :keywords => %w{
                     abstract as assert boolean byte case catch
                     char class def default do double
                     else extends false final finally float for
                     if implements import instanceof int interface
                     long new null package print println
                     private protected public return short
                     static super switch synchronized this throw
                     throws true try void while})


FORMATTERS.for('session',
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
               :string  => "impossible string....",
               :prompt  =>
                  '^(\$|\w+\[.*?\]|[-\w~/\\\\:.]+[>$#])(([^\n]*(\\\\\n|,\n))*[^#\n]*)')

FORMATTERS.for('sh',
               :aka     => %w{ shell },
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
               :string  => '".*?"',
               :keywords =>
                %w{ break case cd cp continue do done echo elif else esac eval 
                    exec exit export fi for if in mkdir rm then while until
                    read readonly set shift trap umask wait },
               :extra_keywords => '^(\w+\[.*?\])(.*)')

FORMATTERS.for('sql',
               :comment => '--.*',
               :callout => %r{--#{CO}},
               :string  => STD_STRING,
#               :string  => "('|\").*?\\1",
               :keywords =>
                   %w{ add alter create decimal delete table int integer char varchar
                       text timestamp
                       not null primary foreign key 
                       default unique index on references constraint select 
                       from where and or
                       union sort by desc asc having group limit order})

FORMATTERS.for('text',
               :aka     => %w{ vb visualbasic },
               :comment => '#.*',
               :string  => STD_STRING)
#               :string  => "('|\").*?\\1")

FORMATTERS.for('plain',
               :callout => %r{#{CO}},
               :comment => "\001",
               :string  => "\002")

FORMATTERS.for('xml',
               :aka     => %w{ html rhtml xml dtd xsl xslt erb jsp },
               :comment => '<!-- .*? -->',
               :callout => %r{<!-- #{CO} -->|//\s*#{CO}|#\s*#{CO}},
               :wtf     => %r{<!--\s*(<wtf\s+linkend=".*?">.*?</wtf>)\s*-->},
               :string  => '".*?"',
               :keywords =>
                   %w{ DOCTYPE ELEMENT ENTITY ATTRIBUTE SYSTEM },
               :extra_keywords => '<(/|\?)?[-:\w]+.*?>',
               :attributes     => '[-\w]+=')

FORMATTERS.for('xqy',
              :aka     => %w{ xquery },
              :comment => '\(:.*?:\)|<!-- .*? -->',
              :callout => %r{\(:#{CO}:\)|<!-- #{CO} -->},
              :string  => '".*?"',
              :keywords => %w{ module declare function variable 
                    default option external import schema as at
                    in case typeswitch if then else for let
                    where order\ by return to or and
                    div idiv mod },
              :extra_keywords => '<(/|\?)?[-:\w]+>?|(document|element|attribute|text|comment|processing-instruction|empty-sequence|node|document-node|schema-attribute)\(\)')


FORMATTERS.for('yml',
               :aka     => %w{ yaml },
               :comment => '#.*',
               :callout => SCRIPT_CALLOUT,
               :keywords => %w{ have_to_have_at_least_one_keyword },
               :extra_keywords => '\w+:',
               :string  => STD_STRING)
#               :string  => "('|\").*?\\1")

FORMATTERS.for('cs',
               :comment => '(/\*(.|\n)*?\*/)|//.*',
               :callout => C_CALLOUT,
               :string  => '".*?"',
               :keywords =>
                 %w{abstract as base bool break
                    byte case catch char checked
                    class const continue decimal default
                    delegate do double else enum
                    event explicit extern false finally
                    fixed float for foreach goto
                    if implicit in int interface
                    internal is lock long namespace
                    new null object operator out
                    override params private protected public
                    readonly ref return sbyte sealed
                    short sizeof stackalloc static string
                    struct switch this throw true
                    try typeof uint ulong unchecked
                    unsafe ushort using virtual void
                    volatile while},
                :extra_keywords =>
                    '(^\#\s*(define|else|endif|ifdef|if|ifndef|include|undef))',
                :attributes => '\[Test[A-Za-z]*\]')

=begin

 'pascal' => 
 {
     comment           => '{.*}',
     keywords          => [ qw(and array as asm begin case class const constructor
                            destructor div do downto else end except exports
                            file finalization finally for function goto if
                            implementation in inherited initialization inline
                            interface is label library mod nil not object of
                            or packed procedure program property raise record
                            repeat set shl shr string then threadvar to try
                            type unit until uses var while with xor
                            absolute abstract assembler automated cdecl default
                            dispid dynamic export external far forward index
                            message name near nodefault override pascal
                            private protected public published read
                            register resident stdcall stored virtual write
			    )],
			    string            => "'.*?'"
			},

 'eiffel' =>
 {
     comment           => '--.*',
     keywords          => [ qw(alias all and as check class creation
			    debug deferred do else else elseif end
			    ensure expanded export external feature
			    from frozen if if implies implies indexing
			    infix inherit inspect invariant is is is
			    like local loop not obsolete old once or
			    prefix redefine rename require rescue
			    retry select strip then undefine unique
			    until variant when xor)],
			    string            => "'.*?'",
			},

 'aop' =>           # java plus a few
 {
     comment           => '(/\*(.|\n)*?\*/)|//.*',
     keywords          => [ qw(abstract advise aspect before boolean break byte byvalue
			    case cast catch char class const
			    continue do double else extends
			    false final finally float for future
			    generic goto if implements import
			    instanceof int interface long native
			    new null package private protected
			    public return short static super
			    switch synchronized this throws
			    transient true try void volatile while)],
			    string            => '".*?"'
			},
 'none' =>
 {
     comment           => '#.*',
     keywords          => [ ],
     string            => "('|\").*?\1"
     },



 'sh' =>
 {
     comment           => '#.*',
     keywords          => [ qw(break case cd continue do done elif else esac eval 
			    exec exit export fi for if in then while until
			    read readonly set shift test trap umask wait)],
     string            => '".*?"',
     prompt            => '^(\w+\[.*?\])(.*)',
 },


 'yacc' =>
 {
     comment           => '(/\*(.|\n)*?\*/)|//.*',
     keywords          => [qw(%{ %} %% %union %token %type
			      asm auto break case char continue default do 
			      double else enum extern float for fortran goto 
			      if int long register return short sizeof static
			      struct switch typedef union unsigned while void 
			      class const delete friend inline new operator 
			      overload private protected public virtual)],
     keyword_patterns  => '(^\#\s*(define|else|endif|if|ifdef|ifndef|include|undef))',
			      string            => '".*?"'
			  },

 );
=end


######################################################################
#
# Formatters for various languages

class Formatter


  attr_reader :truncated


  def Formatter.supports?(lang)
    FORMATTERS[lang]
  end

  def Formatter.for_language(lang, args)

    case lang
    when 'interact'
      InteractFormatter.new(args)
    else
      defn = FORMATTERS[lang] or fail "Don't know about language #{lang}"
      CodeFormatter.new(defn, args)
    end
  end

  def common_setup(args)
    @f_number   = args['number'] == "yes" || args['forcenumber'] == "yes"
    @f_indent   = @f_number || (args['indent'] == "yes")
    @f_verbatim = args['verbatim'] == "yes"
    @f_crossref = args['crossref'] == "yes"
    @lineno    = 0
    @calloutno = 0
    @args      = args
  end

  def prefix
#    if @f_indent
    if @f_number
      if @lineno == 1
        prefix = "Line 1"
      else
        if (@lineno % 5).zero?
          prefix = @lineno.to_s
        else
          prefix = "-"
        end
      end
      %{ prefix="#{prefix}"}
    else
      prefix = ""
    end
  end

  # If the line ends with <labelid="..."/> insert the appropriate ID tag
  # and line number.
  # If the line ends with <callout id="..."/>, do the same, but instead
  # add the next callout number. Also, turn on line numbering if
  # a label is seen

  def handle_crossref(line)
    return nil if @f_verbatim || !@callout
    if line.sub!(@callout, '') && @f_crossref
      callout_spec = $&
      if callout_spec =~ %r{<(label|callout) id="(.*?)"\s*/>}
        linetype = $1
        id       = $2
#      line.sub!(/#@comment\s*$/, '')
        extra = if linetype == "label"
                  %{lineno="#{@lineno}"}
                else
#                  @calloutno += 1
                  @calloutno = @lineno   # because we don't display callouts
                  %{calloutno="#{@calloutno}"}
                end
        return %{<codelinenumber id="#{id}" #{extra} />}
      end
    end
    nil
  end

  # Look for <wtf linkend=".."> and return it
  def handle_wtf(line)
    return "" if @f_verbatim || !@wtf
    if line.sub!(@wtf, '')
      $1
    else
      ''
    end
  end

end

######################################################################

class CodeFormatter < Formatter

  
  def initialize(defn, args)
    common_setup(args)
    @truncated = false
    @callout   = defn.callout
    @wtf       = defn.wtf
  end


  def convert(code)
    result = []
    extras = []
    code.each do |line|
      if line =~ /(START|END)_HIGHLIGHT/
        highlight = ($1 == "START") ? ' highlight="yes"' : ''
      else
        @lineno += 1

        extra = handle_crossref(line)
        extras << extra if extra
        result << line.gsub(%r{</?code:bold>}, '')
      end
    end
    [ result, extras ]
  end



end

##################################################

class InteractFormatter < Formatter


  def initialize(args)
    common_setup(args)
  end

  def convert(code)
    prefix = ""
    last_prefix = ""
    result = []

    code.each do |line|
      @lineno += 1
      if line.sub!(/^%%%/, '')
        prefix = "<="
      else
        prefix = "=>"
      end

      if prefix == last_prefix
        prefix = "  " 
      else
        last_prefix = prefix
      end
      result << "#{prefix}| #{line}"
    end
    [ result, [] ]
  end

end


######################################################################
#
# Given a chunk of code, write it out nicely, highlighing keywords
# etc

class CodeWriter

  def initialize(code, args, code_count)
    @code = code
    @args = args
    @code_count = code_count

    @language = @args['language']

    if !@language && @args['file'] && @args['file'] =~ /\.(\w+)$/
      @args['language'] = @language = $1
      unless Formatter.supports?(@language)
        @language = "text"
      end
    end

    @language ||= 'text'

    @formatter = Formatter.for_language(@language, args)
  end

  def emit(outfile)
    args = ""

    if SKIP_LEADING && @args['file']
      @args['file'].sub!(SKIP_LEADING, '')
    end

    # no livecode if no filename
    if @args['file'].nil? || @args['showname'] == 'no'
      @args['livecode'] = nil
    end

    output_image = "images/code/listing_%05d.png" % @code_count
    @args['code_listing'] = output_image
    content, extras  = @formatter.convert(@code)

    # find the longest line. If it's less that 70 chars, we pad the first line
    # to 70. This means that we'll generate wide enough PNGs not to get rescaled 
    # by the Kindle
    max_width = 0
    content.each {|line| max_width = line.size if line.size > max_width}
    if max_width < 70
      content[0] = content[0]
    end

    # Don't show more than 40 lines on a Kindle
    if content.size > 40
      content = content[0, 39] << "   ... truncated to fit ..."
    end

    content = content.join("\n").strip
    if content.empty?
      STDERR.puts "!!\n!! CODE COUNT #{@code_count} SAMPLE EMPTY\n!!open"

      outfile.puts("<br/><em>(code sample empty)</em><br/>")
      return
    end

    content = content.gsub(/\\/, '\0\0').gsub(/%/, '\\%\\')
    # STDERR.puts content
    File.unlink(output_image) if File.exist?(output_image)

    draw = Magick::Draw.new 
    draw.font = "#{EBOOK_SUPPORT}/fonts/Inconsolata.ttf"
    draw.pointsize = 18
    metrics = draw.get_multiline_type_metrics(content)
    width = metrics.width
    width = 500 if width < 500
    img = Magick::Image.new(width + 4, metrics.height)
    draw.annotate(img,  0, 0, 4, metrics.ascent, content)
    # STDERR.puts("mobi-book/#{output_image}")
    img.write("mobi-book/#{output_image}")

    @args.each {|k,v| args << %{ #{k}="#{v}"} if v }

    outfile.puts "<imagecode#{args} />" + extras.join
  end
end

######################################################################
#
# We've seen the start of a <code> block. This class gets invoked
# to parse the block and emit the appropriate XML

class CodeReader

  def initialize(terminator, line, infile, outfile, code_count)
    @terminator = terminator
    @infile  = infile
    @outfile = outfile
    @code_count = code_count

    parse_args(line.chomp)
    case @terminator
    when 'interact'
      @args['language'] = 'interact'
    when 'ruby', 'result'
      @args['language'] = 'ruby'
    end
  end

  def run
    code_array = if @inline_code
                   read_inline
                 else
                   read_from_file
                 end

    code = normalize(code_array)

    turn_on_line_numbering_if_labels_in(code)

    writer = CodeWriter.new(code, @args, @code_count)
    writer.emit(@outfile)
  end

  private

  # We're looking at <code...>
  # We need to extract any arguments that follow, potentially reading
  # additional lines. This isn' a proper XML parse (because our input file
  # can't be valid XML if it contains inline code chunks)

  def parse_args(line)

    # Remember how many spaces there are at the start of the line
    @leader = ""
    if line =~ /^\s+/
      @leader = $&
    end

    # read any additional lines to make up the full argument list
    until line =~ />/
      newline = @infile.gets
      fail "Couldn't find and of <code... line" unless newline
      line << newline.chomp
    end

    @args = DEFAULT_ARGS.dup
    if line =~ %r{^(\s*)<(code|result|ruby)\s+(.*)/?>}
      arg_text = $3
      arg_text.scan(/([-\w]+)=(["'])(.*?)\2/) do |name, unused, val|
        unless name == 'number'
          unless DEFAULT_ARGS.has_key?(name)
            fail "Invalid argument to <code>: '#{name}'" 
          end
          @args[name] = val
        end
      end
    end

    @inline_code = line !~ %r{/(code)?>}

    if @inline_code && @args['showname'] && @args['showname'] != 'no'
      @args['file'] = @args['showname']
      @args['showname'] = 'yes'
    end

    # Ignore requests for line number. Now happens automatically
    # whe you have a label

    @args.delete('number') if @args['number'] == "yes"
  end

  # Read code up to a </code> directive
  def read_inline
    res = []
    has_cdata = false
    start = @infile.lineno
    while line = @infile.gets
      break if line =~ %r{^#@leader</#@terminator>}
      res << line
      has_cdata = true if @args['verbatim'] == 'no' && line =~ /!\[CDATA\[/i
    end
    fail "Unterminated <code> block starting on line #{start}" unless line
    res = remove_cdata_from(res) if has_cdata
    res
  end

  # Remove a CDATA section from an array containing a code block
  # (leaving the content intact). As of 2006/11/14, we only remove
  # CDATA if it's the first line of the source
  def remove_cdata_from(code)
    return code if !code[0] || code[0] !~ /<!\[CDATA\[/i

    res = []
    line = code.shift.sub(/<!\[CDATA\[/i, '')
    res << line unless line =~ /^\s*$/
    looking_for_end = true

    code.each do |line|
      if looking_for_end && line.sub!(/\]\]>/, '')
        looking_for_end = false
        res << line unless line =~ /^\s*$/
      else
        res << line
      end
    end
    res
  end

  # read code from a file
  def read_from_file
    fn = @args['file'] || fail("Missing file name in <code>")
    content = File.readlines(fn)
    content.pop while content[-1] =~ /^\s*$/
    content
  end

  # remove tags, and strip out unneeded portions of code
  def normalize(code_array)
    part = @args['part']
    res = []

    if @args['start']
      start_regexp = Regexp.new(@args['start'])
      end_regexp = @args['end'] || @args['end-exclude']
      fail "start= but no end=/end-exclude=" unless end_regexp
      end_regexp = Regexp.new(end_regexp)
    else
      start_regexp = nil
    end

    # if there's a part or start argument, we aren't copying initially
    copying = !(part || start_regexp)
    code_array.each do |line|

      line.chomp!

      # expand tabs!
      1 while line.sub!(/\t+/) { ' ' * ($&.length*8 - $`.length % 8) }

      line.rstrip!

      if part
        if line =~ /(\s*).*START:\s*#{part}([^-a-zA-Z0-9_.]|$)/
          copying = true
          next
        end
        
        if line =~ /END:\s*#{part}([^-a-zA-Z0-9_.]|$)/
          copying = false
          next
        end
      end

      if start_regexp
        if line =~ start_regexp
          copying = true
        end

        if copying && @args["end-exclude"] && line =~ end_regexp
          copying = false
          next
        end
      end
      
      if copying 
        if @args['verbatim'] == "yes" || line !~ /START:|END:/
          res << line
        end
      end

      if start_regexp && copying && line =~ end_regexp
        copying = false
      end

    end

    fail("Can't find part '#{part}'") if part  && res.empty?

    # Now reduce all lines to their natural left margin
    bring_to_margin(res)

    # And remove trailing blank lines

    res.pop until res.empty? or res[-1] !~ /^\s*$/
    res
  end


  def turn_on_line_numbering_if_labels_in(code)
    return if @args["verbatim"] == "yes"
    code.each do |line|
      if line =~ /<label\s+id="/
        @args["number"] ||= "yes"  # Don't override "no"
        return
      end
    end
  end

  # Given a set of lines, shuffle them across until they meet the left
  # margin
  def bring_to_margin(res)
    leader = -1
    res.each do |line|
      next if line.empty?
      line =~ /^\s*/
      leading_spaces = $&.length
      if leader < 0 || leading_spaces < leader
        leader = leading_spaces
      end
    end

    if leader > 0
      res.each do |line|
        line[0,leader] = ""
      end
    end
  end

end

######################################################################

def contents_of(basename)
  xml = basename + ".xml"
  pml = basename + ".pml"
  created = false

  fail "Can't find #{pml}" unless File.exist?(pml)

  if !File.exist?(xml) || File.mtime(xml) <= File.mtime(pml)
    $stderr.puts "Preprocessing: #{pml}"
    created = true
    File.open(pml) do |ip|
      File.open(xml, "w") do |op|
        preprocess(ip, op)
      end
    end
  end
    
  $stderr.puts "Including:     #{pml}"
  content = File.read(xml).
    sub(%r{<\?xml.*?>}, '').
    sub(%r{<!DOCTYPE[^>]*[ \t\r\n]+\[.*?\]>}m, '').
    sub(%r{<!DOCTYPE.*?>}m, '')

  File.delete(xml) if created

  content
end

# Look for lines of the form <pml:include file="..."/>. 
# This invites us to substitute the contents of the given
# file at this point. Normally we'd look for the .pml file and
# generate a .xml file from it. However, if the .xml file exists and
# is more recent than the .pml, we just go ahead and use it


def process_includes(content)

  # Look for <pml:ignore lines and ignore them :)
  content = content.gsub(%r{<pml[-:]ignore\s+file="(.*?)"\s*/>}, '')

  # do this in two steps to avoid problems with recursive regexps
  includes = {}

  content.gsub(%r{<pml[-:]include\s+file="(.*?)"\s*/>}) do
    includes[$1] = "unknown"
  end

  includes.each_key {|file| includes[file] = contents_of(file) }

  content.gsub(%r{<pml[-:]include\s+file="(.*?)"\s*/>}) do
    includes[$1]
  end
end

######################################################################


def preprocess(infile, outfile)

  result = ""
  op = StringIO.new(result, "w")
  
  ip = StringIO.new(process_includes(infile.read))

  begin
    while line = ip.gets

      case line
      when /^\s*<(code|interact|ruby|result)(>|\s)/
        CodeReader.new($1, line, ip, op, $code_count).run
        $code_count += 1
      else
        op.puts line
      end
    end
  rescue
    STDERR.puts "\n\nError: #{$!.message} at line #{ip.lineno}"
    STDERR.puts "'#{line}'"
raise
    exit(1)
  end

  outfile.print result # process_includes(result)
end


result = ""
$code_count = 0
op = StringIO.new(result, "w")
preprocess(STDIN, op)

CODE_XREF.map_xrefs(result)


