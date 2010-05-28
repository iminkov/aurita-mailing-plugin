
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter_element

module Aurita
module Plugins
module Mailing

  class Newsletter_Element < Aurita::Model
    table :newsletter_element, :public
    primary_key :newsletter_element_id, :newsletter_element_id_seq

  end

end
end
end

