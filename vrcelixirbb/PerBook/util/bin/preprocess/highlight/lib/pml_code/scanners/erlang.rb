module CodeRay
module Scanners

  class Erlang < Scanner

    include Streamable
    
    register_for :erlang, :erl
    file_extension 'erl'

    RESERVED_WORDS = [
        'after', 'begin', 'case', 'catch', 'cond', 'end', 'fun', 'if',
        'let', 'of', 'query', 'receive', 'try', 'when' ]

    PREDEFINED_FUNCTIONS = [
        'abs', 'append_element', 'apply', 'atom_to_list', 'binary_to_list',
        'bitstring_to_list', 'binary_to_term', 'bit_size', 'bump_reductions',
        'byte_size', 'cancel_timer', 'check_process_code', 'delete_module',
        'demonitor', 'disconnect_node', 'display', 'element', 'erase', 'exit',
        'float', 'float_to_list', 'fun_info', 'fun_to_list',
        'function_exported', 'garbage_collect', 'get', 'get_keys',
        'group_leader', 'hash', 'hd', 'integer_to_list', 'iolist_to_binary',
        'iolist_size', 'is_atom', 'is_binary', 'is_bitstring', 'is_boolean',
        'is_builtin', 'is_float', 'is_function', 'is_integer', 'is_list',
        'is_number', 'is_pid', 'is_port', 'is_process_alive', 'is_record',
        'is_reference', 'is_tuple', 'length', 'link', 'list_to_atom',
        'list_to_binary', 'list_to_bitstring', 'list_to_existing_atom',
        'list_to_float', 'list_to_integer', 'list_to_pid', 'list_to_tuple',
        'load_module', 'localtime_to_universaltime', 'make_tuple', 'md5',
        'md5_final', 'md5_update', 'memory', 'module_loaded', 'monitor',
        'monitor_node', 'node', 'nodes', 'open_port', 'phash', 'phash2',
        'pid_to_list', 'port_close', 'port_command', 'port_connect',
        'port_control', 'port_call', 'port_info', 'port_to_list',
        'process_display', 'process_flag', 'process_info', 'purge_module',
        'put', 'read_timer', 'ref_to_list', 'register', 'resume_process',
        'round', 'send_after', 'send_nosuspend', 'set_cookie',
        'setelement', 'size', 'spawn', 'spawn_link', 'spawn_monitor',
        'spawn_opt', 'split_binary', 'start_timer', 'statistics',
        'suspend_process', 'system_flag', 'system_info', 'system_monitor',
        'system_profile', 'term_to_binary', 'tl', 'trace', 'trace_delivered',
        'trace_info', 'trace_pattern', 'trunc', 'tuple_size', 'tuple_to_list',
        'universaltime_to_localtime', 'unlink', 'unregister', 'whereis'
    ]

    OPERATORS = Regexp.new(%w{
       ++ -- * / < > == /= =:= =/= =< >= + - <- 
       ! ? =
       << >>
       and andalso band bnot bor bsl bsr bxor
       div not or orelse rem xor
    }.map {|o| Regexp.escape(o) }.join("|")) #


    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_FUNCTIONS, :pre_type)


    ATOM_RE = %r{(?:[a-z][a-zA-Z0-9_]*|\'[^\n\']*[^\\]\')}

    VARIABLE_RE = %r{(?:[A-Z_][a-zA-Z0-9_]*)}

    ESCAPE_RE = %r{(?:\\(?:[bdefnrstv\'\"\/]|[0-7][0-7]?[0-7]?|\^[a-zA-Z]))} 

    MACRO_RE = %r{(?:#{VARIABLE_RE}|#{ATOM_RE})}o



    def scan_tokens tokens, options

      state = :initial

      until eos?

        kind = nil
        match = nil

        case state

        when :initial
    
          case
          when match = scan(/^-\w+/)
            kind = :reserved

          when match = scan(/ \s+ | \\\n /x)
            tokens << [match, :space]
            next
            
          when scan(%r{%.*})
            kind = :comment

          when match = scan(/-\[a-z]+/)
            kind = :keyword

          when match = scan(OPERATORS)
            kind = :operator

          when match = scan(%r{"}) #"
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            
          when match = scan(VARIABLE_RE)
            kind = :identifier


          when match = scan(ATOM_RE)
            kind = IDENT_KIND[match]
            if kind == :reserved
              case match
              when 'case', 'default'
                case_expected = true
              end
            end

          when match = scan(MACRO_RE)
            kind = :identifier


          when match = scan(%r{\$(?:#{ESCAPE_RE}|\\[ %]|[^\\])}o)
            kind = :identifier

          when match = scan(%r{[+-]?(?:[2-9]|[12][0-9]|3[0-6])\#[0-9a-zA-Z]+})
            kind = :number

          when match = scan(/[+-]?\d+/)
            kind = :number

          when match = scan(/[+-]?\d+\.\d+/)
            kind = :number
            
          when scan(%r{(0[0-7]*|0[xX][\da-fA-F]+|\d+)[lL]?}) 
            kind = :number
            
            
          when scan(%r{(\d+\.\d*|\.\d+)([eE][-+](\d+)?)?[fFdD]?})
            kind = :number
            
          when scan(%r{\+[eE][-+](\d+)?[fFdD]?})
            kind = :number
            
          when scan(%r{\d+([eE][-+](\d+)?)?[fFdD]?})
            kind = :number

          when match = scan(/[\[:_@\".{}()|;,]/)
            kind = :text
          else
            getch
            kind = :error

          end
        
        when :string
          case
          when scan(/[^\\\n"]+/)
            kind = :content
          when scan(/\\./)
            kind = :content
          when scan(/"/)
            tokens << ['"', :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          else
            raise_inspect "else case \" reached; %p not handled." % peek(1), tokens
          end

        else
          raise_inspect 'Unknown state', tokens

        end

        match ||= matched
        if $CODERAY_DEBUG and not kind
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
