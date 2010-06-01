
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter_element

module Aurita
module Plugins
module Mailing

  class Newsletter < Aurita::Model
    table :newsletter, :public
    primary_key :newsletter_id, :newsletter_id_seq

    use_label :newsletter_name

    def elements(params={})
      amount = params[:amount]
      # We expect rather few newsletter elements, while 
      # there are many concrete classes for Content, 
      # so we use lazy polymorphism. 

      @elements ||= Content.select { |c|
        c.limit(amount) if amount
        c.join(Newsletter_Element).using(:content_id) { |cid| 
          cid.where(:newsletter_id => newsletter_id)
          cid.order_by(Newsletter_Element.newsletter_element_id, :desc)
        }
      }.to_a.map { |c| c.concrete_instance }

      @elements
    end

  end

end
end
end

