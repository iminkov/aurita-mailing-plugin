
require('aurita/plugin_controller')

module Aurita
module Plugins
module Mailing

  class Newsletter_Element_Controller < Plugin_Controller

    def add_article
      form = model_form(:action => :perform_add_article)

      form.add(Aurita::GUI::Hidden_Field.new(:name => :newsletter_id, :value => param(:newsletter_id)))
      form.add(Wiki::GUI::Article_Selection_Field.new(:name        => :article, 
                                                      :label       => tl(:find_article), 
                                                      :num_results => 100, 
                                                      :id          => :article_id_selection))
      form.fields = [ :article, :newsletter_id ]

      form = decorate_form(form)
      return form unless param(:element) == 'app_main_content'

      Aurita::GUI::Page.new(:header => tl(:add_article)) { 
        form
      }
    end

    def perform_add_article
      param[:position] = 0
      perform_add()
      newsletter = Newsletter.get(param(:newsletter_id))
      redirect_to(newsletter) if newsletter
    end

    def perform_delete
      Newsletter_Element.find(1).with(:content_id    => param(:content_id), 
                                      :newsletter_id => param(:newsletter_id)).entity.delete
      newsletter = Newsletter.get(param(:newsletter_id))
      redirect_to(newsletter) if newsletter
    end


  end

end
end
end

