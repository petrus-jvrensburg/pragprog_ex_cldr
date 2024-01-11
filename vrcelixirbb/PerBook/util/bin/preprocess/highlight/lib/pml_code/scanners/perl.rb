module CodeRay
module Scanners

  load :html

  # Original PHP scanner by Stefan Walk.
  class Perl < Scanner

    register_for :perl
    file_extension 'pl'

    KINDS_NOT_LOC = HTML::KINDS_NOT_LOC

    def setup
      @html_scanner = CodeRay.scanner :html, :tokens => @tokens, :keep_tokens => true, :keep_state => true
    end

    def reset_instance
      super
      @html_scanner.reset
    end

    module Words

      KEYWORDS = %w[
          __DATA__      else    lock    qw
          __END__       elsif   lt      qx
          __FILE__        eq      m       s
          __LINE__        exp     ne      sub
          __PACKAGE__     for     no      tr
          and     foreach or      unless
          cmp     ge      package until
          continue        gt      q       while
          CORE    if      qq      xor
          do      le      qr      y

      ]

      TYPES = %w[ int integer float double bool boolean string array object resource ]

      LANGUAGE_CONSTRUCTS = %w[
        die echo empty exit eval include include_once isset list
        require require_once return print unset
      ]

      CLASSES = %w[  ]

      BUILTIN_FUNCTIONS = %w[

          -A      END     length  setpgrp
          -B      endgrent        link    setpriority
          -b      endhostent      listen  setprotoent
          -C      endnetent       local   setpwent
          -c      endprotoent     localtime       setservent
          -d      endpwent        log     setsockopt
          -e      endservent      lstat   shift
          -f      eof     map     shmctl
          -g      eval    mkdir   shmget
          -k      exec    msgctl  shmread
          -l      exists  msgget  shmwrite
          -M      exit    msgrcv  shutdown
          -O      fcntl   msgsnd  sin
          -o      fileno  my      sleep
          -p      flock   next    socket
          -r      fork    not     socketpair
          -R      format  oct     sort
          -S      formline        open    splice
          -s      getc    opendir split
          -T      getgrent        ord     sprintf
          -t      getgrgid        our     sqrt
          -u      getgrnam        pack    srand
          -w      gethostbyaddr   pipe    stat
          -W      gethostbyname   pop     state
          -X      gethostent      pos     study
          -x      getlogin        print   substr
          -z      getnetbyaddr    printf  symlink
          abs     getnetbyname    prototype       syscall
          accept  getnetent       push    sysopen
          alarm   getpeername     quotemeta       sysread
          atan2   getpgrp rand    sysseek
          AUTOLOAD        getppid read    system
          BEGIN   getpriority     readdir syswrite
          bind    getprotobyname  readline        tell
          binmode getprotobynumber        readlink        telldir
          bless   getprotoent     readpipe        tie
          break   getpwent        recv    tied
          caller  getpwnam        redo    time
          chdir   getpwuid        ref     times
          CHECK   getservbyname   rename  truncate
          chmod   getservbyport   require uc
          chomp   getservent      reset   ucfirst
          chop    getsockname     return  umask
          chown   getsockopt      reverse undef
          chr     glob    rewinddir       UNITCHECK
          chroot  gmtime  rindex  unlink
          close   goto    rmdir   unpack
          closedir        grep    say     unshift
          connect hex     scalar  untie
          cos     index   seek    use
          crypt   INIT    seekdir utime
          dbmclose        int     select  values
          dbmopen ioctl   semctl  vec
          defined join    semget  wait
          delete  keys    semop   waitpid
          DESTROY kill    send    wantarray
          die     last    setgrent        warn
          dump    lc      sethostent      write
          each    lcfirst setnetent
      ]

      EXCEPTIONS = %w[
      ]

      CONSTANTS = %w[
        ARGV	STDERR	STDOUT
        ARGVOUT	STDIN
      ]


      PREDEFINED = %w[
      ]

      IDENT_KIND = CaseIgnoringWordList.new(:ident).
        add(KEYWORDS, :reserved).
        add(TYPES, :pre_type).
        add(LANGUAGE_CONSTRUCTS, :reserved).
        add(BUILTIN_FUNCTIONS, :reserved).  # was predefined
        add(CLASSES, :pre_constant).
        add(EXCEPTIONS, :exception).
        add(CONSTANTS, :pre_constant)

      VARIABLE_KIND = WordList.new(:local_variable).
        add(PREDEFINED, :predefined)
    end

    module RE


      HTML_INDICATOR = /<!DOCTYPE html|<(?:html|body|div|p)[> ]/i

      IDENTIFIER = /[a-z_\x7f-\xFF][a-z0-9_\x7f-\xFF]*/i
      VARIABLE = /\$#{IDENTIFIER}/

      OPERATOR = /
        \.(?!\d)=? |      # dot that is not decimal point, string concatenation
        && | \|\| |       # logic
        :: | -> | => |    # scope, member, dictionary
        \\(?!\n) |        # namespace
        \+\+ | -- |       # increment, decrement
        [,;?:()\[\]{}] |  # simple delimiters
        [-+*\/%&|^]=? |   # ordinary math, binary logic, assignment shortcuts
        [~$] |            # whatever
        =& |              # reference assignment
        [=!]=?=? | <> |   # comparison and assignment
        <<=? | >>=? | [<>]=?  # comparison and shift
      /x

    end

    def scan_tokens tokens, options
      if string.respond_to?(:encoding)
        unless string.encoding == Encoding::ASCII_8BIT
          self.string = string.encode Encoding::ASCII_8BIT,
            :invalid => :replace, :undef => :replace, :replace => '?'
        end
      end

      states = [:initial]

      label_expected = true
      case_expected = false

      heredoc_delimiter = nil
      delimiter = nil
      modifier = nil

      until eos?

        match = nil
        kind = nil

        case states.last

        when :initial, :perl
          if match = scan(/\s+/)
            tokens << [match, :space]
            next

          elsif scan(%r! \# .* $ !xo)
            kind = :comment

          elsif match = scan(RE::IDENTIFIER)
            kind = Words::IDENT_KIND[match]
            if kind == :ident && label_expected && check(/:(?!:)/)
              kind = :label
              label_expected = true
            else
              label_expected = false
              if kind == :ident && match =~ /^[A-Z]/
                kind = :constant
              elsif kind == :reserved
                case match
                when 'class'
                  states << :class_expected
                when 'function'
                  states << :function_expected
                when 'case', 'default'
                  case_expected = true
                end
              elsif match == 'b' && check(/['"]/)  # binary string literal
                modifier = match
                next
              end
            end

          elsif scan(/(?:\d+\.\d*|\d*\.\d+)(?:e[-+]?\d+)?|\d+e[-+]?\d+/i)
            label_expected = false
            kind = :float

          elsif scan(/0x[0-9a-fA-F]+/)
            label_expected = false
            kind = :hex

          elsif scan(/\d+/)
            label_expected = false
            kind = :integer

          elsif scan(/'/)
            tokens << [:open, :string]
            if modifier
              tokens << [modifier, :modifier]
              modifier = nil
            end
            kind = :delimiter
            states.push :sqstring

          elsif match = scan(/["`]/)
            tokens << [:open, :string]
            if modifier
              tokens << [modifier, :modifier]
              modifier = nil
            end
            delimiter = match
            kind = :delimiter
            states.push :dqstring

          elsif match = scan(RE::VARIABLE)
            label_expected = false
            kind = Words::VARIABLE_KIND[match]

          elsif scan(/\{/)
            kind = :operator
            label_expected = true
            states.push :perl

          elsif scan(/\}/)
            if states.size == 1
              kind = :error
            else
              states.pop
              if states.last.is_a?(::Array)
                delimiter = states.last[1]
                states[-1] = states.last[0]
                tokens << [matched, :delimiter]
                tokens << [:close, :inline]
                next
              else
                kind = :operator
                label_expected = true
              end
            end

          elsif scan(/@/)
            label_expected = false
            kind = :exception


          elsif match = scan(/<<<(?:(#{RE::IDENTIFIER})|"(#{RE::IDENTIFIER})"|'(#{RE::IDENTIFIER})')/o)
            tokens << [:open, :string]
            warn 'heredoc in heredoc?' if heredoc_delimiter
            heredoc_delimiter = Regexp.escape(self[1] || self[2] || self[3])
            kind = :delimiter
            states.push self[3] ? :sqstring : :dqstring
            heredoc_delimiter = /#{heredoc_delimiter}(?=;?$)/

          elsif match = scan(/#{RE::OPERATOR}/o)
            label_expected = match == ';'
            if case_expected
              label_expected = true if match == ':'
              case_expected = false
            end
            kind = :operator

          else
            getch
            kind = :error

          end

        when :sqstring
          if scan(heredoc_delimiter ? /[^\\\n]+/ : /[^'\\]+/)
            kind = :content
          elsif !heredoc_delimiter && scan(/'/)
            tokens << [matched, :delimiter]
            tokens << [:close, :string]
            delimiter = nil
            label_expected = false
            states.pop
            next
          elsif heredoc_delimiter && match = scan(/\n/)
            kind = :content
            if scan heredoc_delimiter
              tokens << ["\n", :content]
              tokens << [matched, :delimiter]
              tokens << [:close, :string]
              heredoc_delimiter = nil
              label_expected = false
              states.pop
              next
            end
          elsif scan(heredoc_delimiter ? /\\\\/ : /\\[\\'\n]/)
            kind = :char
          elsif scan(/\\./m)
            kind = :content
          elsif scan(/\\/)
            kind = :error
          end

        when :dqstring
          if scan(heredoc_delimiter ? /[^${\\\n]+/ : (delimiter == '"' ? /[^"${\\]+/ : /[^`${\\]+/))
            kind = :content
          elsif !heredoc_delimiter && scan(delimiter == '"' ? /"/ : /`/)
            tokens << [matched, :delimiter]
            tokens << [:close, :string]
            delimiter = nil
            label_expected = false
            states.pop
            next
          elsif heredoc_delimiter && match = scan(/\n/)
            kind = :content
            if scan heredoc_delimiter
              tokens << ["\n", :content]
              tokens << [matched, :delimiter]
              tokens << [:close, :string]
              heredoc_delimiter = nil
              label_expected = false
              states.pop
              next
            end
          elsif scan(/\\(?:x[0-9A-Fa-f]{1,2}|[0-7]{1,3})/)
            kind = :char
          elsif scan(heredoc_delimiter ? /\\[nrtvf\\$]/ : (delimiter == '"' ? /\\[nrtvf\\$"]/ : /\\[nrtvf\\$`]/))
            kind = :char
          elsif scan(/\\./m)
            kind = :content
          elsif scan(/\\/)
            kind = :error
          elsif match = scan(/#{RE::VARIABLE}/o)
            kind = :local_variable
            if check(/\[#{RE::IDENTIFIER}\]/o)
              tokens << [:open, :inline]
              tokens << [match, :local_variable]
              tokens << [scan(/\[/), :operator]
              tokens << [scan(/#{RE::IDENTIFIER}/o), :ident]
              tokens << [scan(/\]/), :operator]
              tokens << [:close, :inline]
              next
            elsif check(/\[/)
              match << scan(/\[['"]?#{RE::IDENTIFIER}?['"]?\]?/o)
              kind = :error
            elsif check(/->#{RE::IDENTIFIER}/o)
              tokens << [:open, :inline]
              tokens << [match, :local_variable]
              tokens << [scan(/->/), :operator]
              tokens << [scan(/#{RE::IDENTIFIER}/o), :ident]
              tokens << [:close, :inline]
              next
            elsif check(/->/)
              match << scan(/->/)
              kind = :error
            end
          elsif match = scan(/\{/)
            if check(/\$/)
              kind = :delimiter
              states[-1] = [states.last, delimiter]
              delimiter = nil
              states.push :perl
              tokens << [:open, :inline]
            else
              kind = :string
            end
          elsif scan(/\$\{#{RE::IDENTIFIER}\}/o)
            kind = :local_variable
          elsif scan(/\$/)
            kind = :content
          end

        when :class_expected
          if scan(/\s+/)
            kind = :space
          elsif match = scan(/#{RE::IDENTIFIER}/o)
            kind = :class
            states.pop
          else
            states.pop
            next
          end

        when :function_expected
          if scan(/\s+/)
            kind = :space
          elsif scan(/&/)
            kind = :operator
          elsif match = scan(/#{RE::IDENTIFIER}/o)
            kind = :function
            states.pop
          else
            states.pop
            next
          end

        else
          raise_inspect 'Unknown state!', tokens, states
        end

        match ||= matched
        if $CODERAY_DEBUG and not kind
          raise_inspect 'Error token %p in line %d' %
            [[match, kind], line], tokens, states
        end
        raise_inspect 'Empty token', tokens, states unless match

        tokens << [match, kind]

      end

      tokens
    end

  end

end
end
