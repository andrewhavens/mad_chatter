module MadChatter
  module MessageListeners
    class Markdown
      
      # Apply markdown to all messages that pass through
      def handle(message)
        message.html = apply_markdown(message.filtered_text)
        return message
      end
      
      def apply_markdown(text)

        # in very clear cases, let newlines become <br /> tags
        text.gsub!(/^[\w\<][^\n]*\n+/) do |x|
          x =~ /\n{2}/ ? x : (x.strip!; x << "  \n")
        end
        
        # inline code (backticks)
        text.gsub!(%r{(^|\s)(\`)(.+?)\2(\s|$)}, %{\\1<code>\\3</code>\\4})

        # autolink email addresses
        text.gsub!(/([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i) do |x|
          x = %Q{<a href="mailto:#{$&}">#{$&}</a>}
        end

        # autolink urls
        text.gsub!(/(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/(\S)+)?/i) do |x|
          href = $&
           # check if we're in a markdown link
          if $` =~ /[(]/
            x = href
          else
            x = %Q{<a target="_blank" href="#{href}">#{href}</a>}
          end
        end
        
        # reference style links: [link text](http://link.url)
        text.gsub!(%r{\[([^\]]+)\]\((\S+(?=\)))\)}, %{<a target="_blank" href="\\2">\\1</a>})
        
        # bold (must come before italic)
        text.gsub!(%r{(^|\s)(\*\*|__)(.+?)\2(\s|$)}, %{\\1<strong>\\3</strong>\\4})
        
        # italic
        text.gsub!(%r{(^|\s)([*_])(.+?)\2(\s|$)}, %{\\1<em>\\3</em>\\4})
        
        return text
      end
      
    end
  end
end