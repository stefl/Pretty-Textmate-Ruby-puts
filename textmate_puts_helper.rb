require 'pp'

if ENV['TM_BUNDLE_SUPPORT']
  module Kernel
    def caller_to_tm_link c
      file, line, method = parse_caller(c)
      url = "txmt://open?url=file://#{file}&line=#{line}"
      "<a style='float: right; color: #999' href='#{url}'>#{file.split("/").last} #{line} #{"(#{method})" if method}</a>"
    end
    
    def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
            file = Regexp.last_match[1]
        line = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        [file, line, method]
      end
    end
    
    alias_method :orig_puts, :puts
    def puts(*args)
      $orig_stdout = $stdout
      begin
        if $stdout
          out = StringIO.new
          $stdout = out
          orig_puts *args
          $stdout = $orig_stdout if $orig_stdout
          orig_puts "<code style='background-color: #eee; border-bottom: 1px solid white; padding: 0.5em; display: block;'>"
          c = caller[0]
          file, line, method = parse_caller(c)
          c = caller[1] if method == "pp"
          file, line, method = parse_caller(c)
          c = caller[2] if method == "pp"
          orig_puts caller_to_tm_link(c)
          o = out.string.gsub("<", "&lt;").gsub(">","&gt;").gsub("\n", "<br />")
          orig_puts "#{o || "&nbsp;"}</code>"
        end
      ensure
        $stdout = $orig_stdout
      end
    end
    
    alias_method :orig_pp, :pp
    def pp(*args)
      if(args[0] && args[0].respond_to?(:pp))
        args[0].pp 
      else
        $orig_stdout = $stdout
        begin
          if $stdout
            out = StringIO.new
            $stdout = out
            orig_pp *args
            $stdout = $orig_stdout if $orig_stdout
            orig_puts "<code style='background-color: #eee; border-bottom: 1px solid white; padding: 0.5em; display: block;'>"
            orig_puts caller_to_tm_link(caller[0])
            a = out.string.gsub("<", "&lt;").gsub(">","&gt;").gsub("\n", "<br />")
            orig_puts "#{o || "&nbsp;"}</code>"
          end
        ensure
          $stdout = $orig_stdout
        end
      end
    end
  end
end