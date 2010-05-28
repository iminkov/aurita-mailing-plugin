
require('aurita/plugin')

module Aurita
module Plugins
module Mailing


  class Permissions < Aurita::Plugin::Manifest

    register_permission(:edit_newsletters, 
                        :type    => :bool, 
                        :default => true)
    register_permission(:edit_newsletter_subscribers, 
                        :type    => :bool, 
                        :default => true)
    register_permission(:send_newsletters, 
                        :type    => :bool, 
                        :default => true)

  end

end
end
end

