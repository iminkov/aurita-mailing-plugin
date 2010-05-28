
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter

module Aurita
module Plugins
module Mailing

  class Newsletter_Delivery < Aurita::Model
    table :newsletter_delivery, :public
    primary_key :newsletter_delivery_id

  end

end
end
end

