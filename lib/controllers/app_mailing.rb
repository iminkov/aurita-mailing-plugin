
require('aurita/plugin_controller')
Aurita.import_module :gui, :toolbar_button
Aurita.import_plugin_controller :mailing, :newsletter
Aurita.import_plugin_controller :mailing, :newsletter_subscriber
Aurita.import_plugin_controller :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class App_Mailing_Controller < Aurita::Plugin_Controller

    def left
      render_controller(Newsletter_Controller, :edit_box) + 
      render_controller(Newsletter_Subscriber_Controller, :edit_box) +
      render_controller(Newsletter_Subscriber_Group_Controller, :edit_box)
    end

    def main
    end

  end

end
end
end

