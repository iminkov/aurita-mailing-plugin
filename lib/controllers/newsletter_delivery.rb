
require('aurita/plugin_controller')
Aurita.import_plugin_model :mailing, :newsletter_delivery
Aurita.import_plugin_model :mailing, :newsletter
Aurita.import_plugin_model :mailing, :newsletter_subscriber
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class Newsletter_Delivery_Controller < Aurita::Plugin_Controller

    guard(:CRUD) { Aurita.user.may(:edit_newsletters) } 

    def add
      n = Newsletter.get(param(:newsletter_id))

      Page.new(:header => tl(:send_newsletter)) { 
        HTML.b { n.newsletter_name } 
      }
    end

  end

end
end
end

