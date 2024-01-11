# Scanner written by Chris Peterson, 2008-06-12 and submitted to Redmine: 
# http://www.redmine.org/attachments/642/coderay_lua_lexar.patch

module CodeRay
  module Scanners

    class Lua < Scanner

      register_for :lua
      
      include Streamable

      RESERVED_WORDS = [
        'if', 'elseif', 'else', 'then', 
        'end', 'do', 'while', 'true',
        'false', 'in', 'for', 'and', 'or',
        'function', 'local', 'not', 'repeat',
        'return', 'until', 'break',
      ]

      PREDEFINED_TYPES = [
        'nil', 'boolean', 'number', 'string', 'table',
      ]
      
      BUILTIN_LIBS = [
        'package', 'table', 'math', 'string', 'io', 'os', 'debug',
      ]
      
      BUILTIN_METHODS = [
        'loadlib', 'path', 'cpath', 
        'loaded','preloaded','seeall',
        'coroutine', 'create','resume','yield',
        'status','running','wrap',
        'insert','remove','maxn','sort',
        'concat','abs','mod','floor','ceil',
        'min','max','sqrt','math.pow','math.log',
        'exp','log10','deg','math.pi','math.rad',
        'sin','cos','tan','asin','acos',
        'atan','atan2','frexp','ldexp','random',
        'randomseed', 'len','sub','rep','upper',
        'lower','byte','char','dump','format',
        'find','gmatch','gsub','match','open',
        'input','output','close','read','lines',
        'write','flush','stdout','stdin','stderr',
        'popen','type','tmpfile','execute','exit',
        'getenv','setlocale','remove','rename','tmpname',
        'clock','time','date','difftime','debug',
        'getinfo','getlocal','getupvalue','traceback',
        'setlocal','setupvalue','sethook','gethook', 
      ]
      
      BUILTIN_FUNCTIONS = [
        'print', 'pairs','ipairs', 'error', 'load',
        'require', 'getfenv', 'setfenv', 'dofile',
        'loadfile', 'loadstring', 'pcall', 'xpcall',
        'assert', 'type', 'tostring', 'tonumber',
        'select', 'upack', 'next', 'collectgarbage',
        'module', 	
      ]
      
      IDENT_KIND = WordList.new(:ident).
                                        add(RESERVED_WORDS, :reserved).
                                                                       add(PREDEFINED_TYPES, :pre_type).
                                                                                                        add(BUILTIN_LIBS, :predefined).
                                                                                                                                       add(BUILTIN_METHODS, :pre_type).
                                                                                                                                                                       add(BUILTIN_FUNCTIONS, :preprocessor)

      ESCAPE = / [rbfnrtv\n\\'"] | x[a-fA-F0-9]{1,2} | [0-7]{1,3} /x
      UNICODE_ESCAPE =  / u[a-fA-F0-9]{4} | U[a-fA-F0-9]{8} /x

      def scan_tokens tokens, options

        state = :initial

        until eos?

          kind = nil
          match = nil
          
          case state

          when :initial

            if scan(/ \s+ | \\\n /x)
              kind = :space

            elsif scan(%r! --[^\n\\]* (?: \\. [^\n\\]* )* | --\[\[ (?: .*? \]\] | .* ) !mx)
              kind = :comment

            elsif scan(/ [-+*\/=<>?:;,!&^|()\[\]{}~%]+ | \.(?!\d) /x)
              kind = :operator

            elsif match = scan(/ [#A-Za-z_][A-Za-z_0-9]* /x)
              kind = IDENT_KIND[match]
              if kind == :pre_type and check(/[^\.\:\(\']/)
                kind = :ident
              end
              
            elsif match = scan(/L?"/)
              tokens << [:open, :string]
              if match[0] == ?L
                tokens << ['L', :modifier]
                match = '"'
              end
              state = :string
              kind = :string

            elsif scan(/ L?' (?: [^\'\n\\] | \\ #{ESCAPE} )? '? /ox)
              kind = :char

            elsif scan(/0[xX][0-9A-Fa-f]+/)
              kind = :hex

            elsif scan(/(?:0[0-7]+)(?![89.eEfF])/)
              kind = :oct

            elsif scan(/(?:\d+)(?![.eEfF])/)
              kind = :integer

            elsif scan(/\d[fF]?|\d*\.\d+(?:[eE][+-]?\d+)?[fF]?|\d+[eE][+-]?\d+[fF]?/)
              kind = :float

            else
              getch
              kind = :error

            end

          when :string
            if scan(/[^\\\n"]+/)
              kind = :content
            elsif scan(/"/)
              tokens << ['"', :string]
              tokens << [:close, :string]
              state = :initial
              next
            elsif scan(/ \\ (?: #{ESCAPE} | #{UNICODE_ESCAPE} ) /mox)
              kind = :char
            elsif scan(/ \\ | $ /x)
              tokens << [:close, :string]
              kind = :error
              state = :initial
            else
              raise_inspect "else case \" reached; %p not handled." % peek(1), tokens
            end

          when :include_expected
            if scan(/<[^>\n]+>?|"[^"\n\\]*(?:\\.[^"\n\\]*)*"?/)
              kind = :include
              state = :initial

            elsif match = scan(/\s+/)
              kind = :space
              state = :initial if match.index ?\n

            else
              getch
              kind = :error

            end

          else
            raise_inspect 'Unknown state', tokens

          end

          match ||= matched
          if $DEBUG and not kind
            raise_inspect 'Error token %p in line %d' %
                                                       [[match, kind], line], tokens
          end
          raise_inspect 'Empty token', tokens unless match

          tokens << [match, kind]

        end

        if state == :string
          tokens << [:close, :string]
        end

        tokens
      end

    end

  end
end
