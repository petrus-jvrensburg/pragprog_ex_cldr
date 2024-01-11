module CodeRay
module Scanners
  
  class Swift < Scanner

    register_for :swift
    file_extension 'swift'
    
    RESERVED_WORDS = %w{
      break 
      class
      case
      catch
      continue
      default
      didSet
      do
      else
      enum
      for
      func
      get
      if
      import
      in
      let
      return
      self
      set
      struct
      super
      switch
      try
      unowned
      var
      weak
      where
      while
      willSet
    }

    DIRECTIVES = %w{
      @assignment
      @class_protocol
      @final
      @lazy
      @noreturn
      @NSCopying
      @NSManaged
      @objc
      @optional
      @required
      @IBAction
      @IBDesignable
      @IBInspectable
      @IBOutlet
      @autoclosure
      @noreturn 
      override
      extension
   }

    IDENT_KIND = CaseIgnoringWordList.new(:ident).
      add(RESERVED_WORDS + DIRECTIVES, :reserved)
    

  private
    def scan_tokens(tokens, options)

      state = :initial
      last_token = ''

      until eos?

        kind  = nil
        match = nil

        case state
        when :initial
          
          if scan(/ \s+ /x)
            tokens << [matched, :space]
            next
            
          elsif scan(%r! // .*  !x)
            tokens << [matched, :comment]
            next

          elsif scan(%r! /\* .*? \*/ !mx)
            tokens << [matched, :comment]
            next
            
          elsif match = scan(/ <[>=]? | >=? | :=? | [-+=*\/;.,@\^|\(\)\[\]] | \.\. /x)
            kind = :operator
          
            
          elsif match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match]
            
          elsif match = scan(/ " /x)
            tokens << [:open, :string]
            state = :string
            kind = :delimiter
            
          elsif scan(/ . /x)
            kind = :other

          else
            kind = :error
            getch

          end
          
        when :string
          case
          when scan(/[^\"\\]+/)
            kind = :content
          when scan(/"/)
            tokens << ['"', :delimiter]
            tokens << [:close, :string]
            state = :initial
            next
          when scan(/\\\(/)
            kind = :content
          when scan(/\\./)
            kind = :content
          end

        else
          raise 'bad state #{state}', tokens
          
        end
        
        match ||= matched
        if $CODERAY_DEBUG and not kind
          raise_inspect 'Error token %p in line %d' %
            [[match, kind], line], tokens, state
        end
        raise_inspect 'Empty token', tokens unless match

        last_token = match
        tokens << [match, kind]
        
      end

      tokens
    end

  end

end
end
