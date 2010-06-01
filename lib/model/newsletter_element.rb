
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter_element

module Aurita
module Plugins
module Mailing

  class Newsletter_Element < Aurita::Model
    table :newsletter_element, :public
    primary_key :newsletter_element_id, :newsletter_element_id_seq

  end

  class Newsletter < Aurita::Model
    def elements
      @elements ||= Content.select { |c|
        c.limit(amount) if amount
        c.join(Newsletter_Element).using(:content_id) { |cid| 
          cid.where(Newsletter_Element.newsletter_id == newsletter_id)
          cid.order_by(Newsletter_Element.newsletter_element_id, :desc)
        }
      }.to_a.map { |c| c.concrete_instance }

      @elements
    end
  end

end
end
end

