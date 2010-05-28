
require('aurita/plugin_controller')
Aurita.import_module :gui, :entity_selection_list_field
Aurita.import_plugin_model :mailing, :newsletter
Aurita.import_plugin_model :mailing, :newsletter_subscriber
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class Newsletter_Subscriber_Controller < Aurita::Plugin_Controller

    guard(:CRUD) { Aurita.user.may(:edit_newsletter_subscribers) } 

    def form_groups
      [ 
        :subscriber_group_ids, 
        Newsletter_Subscriber.email, 
        Newsletter_Subscriber.forename, 
        Newsletter_Subscriber.surname
      ]
    end

    def add
      form         = add_form()
      group_select = Entity_Selection_List_Field.new(:name  => Newsletter_Subscriber.subscriber_group_ids, 
                                                     :label => tl(:subscriber_groups), 
                                                     :model => Newsletter_Subscriber_Group)
      form[:subscriber_group_ids] = group_select

      Page.new(:header => tl(:add_subscriber)) { form } 
    end

    after(:perform_add, :perform_delete, :perform_update) { |controller|
      controller.redirect_to(:blank)
      controller.redirect(:element => :newsletter_subscribers_box_body, :to => :edit_box_body)
    }

    def edit_box
      return unless Aurita.user.may(:edit_newsletter_subscribers)

      box         = Box.new(:id => :newsletter_subscribers_box)
      box.header  = tl(:newsletter_subscribers)
      box.body    = edit_box_body
      box.toolbar = [ 
        GUI::Toolbar_Button.new(:icon   => :add, 
                                :action => 'Mailing::Newsletter_Subscriber/add', 
                                :label  => tl(:add_subscriber)).string
      ]
      box
    end
    def edit_box_body
      entries = Newsletter_Subscriber.find(:all).sort_by(:surname, :asc).to_a
      HTML.ul.no_bullets { 
        entries.map { |n|
          HTML.li { 
            link_to(n, :action => :delete) { Icon.new(:delete).string } + 
            link_to(n, :action => :update) { n.label }
          }
        }
      }
    end

  end

end
end
end
