
require('aurita')
require('aurita-gui/html')
Aurita.import_module :gui, :erb_template

module Aurita
module Plugins
module Mailing

  class Newsletter_Renderer
  include Aurita::GUI
  
    def initialize(newsletter)
      @newsletter = newsletter
      @elements   = false
    end

    def html_body
      @elements ||= @newsletter.elements
      view_string(:newsletter_body, 
                  :elements   => @elements, 
                  :newsletter => @newsletter)
    end

    def multipart_html
      view_string(:newsletter, :content => html_body())
    end

    def multipart_plain
      @elements ||= @newsletter.elements

      @elements.map { |e|
        HTML.div.entry { e.teaser_text }
      }
    end

    def view_string(template, params={})
      template = "#{template}.rhtml" if template.is_a?(Symbol)
      ERB_Template.new(template, params, :mailing).string
    end

  end

end
end
end

