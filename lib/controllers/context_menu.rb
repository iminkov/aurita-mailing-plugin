
require('aurita/controller')
Aurita::Main.import_controller :context_menu
Aurita.import_module :context_menu_helpers

module Aurita
module Plugins
module Mailing

  class Context_Menu_Controller < Aurita::Plugin_Controller
  include Aurita::Context_Menu_Helpers

    def newsletter
    end

    def newsletter_subscriber
    end

    def newsletter_subscriber_group
    end

  end

end
end
end

