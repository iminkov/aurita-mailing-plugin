
require('aurita/plugin_controller')
Aurita.import_plugin_model :mailing, :newsletter
Aurita.import_plugin_model :mailing, :newsletter_subscriber
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class Newsletter_Subscriber_Group_Controller < Aurita::Plugin_Controller

    guard(:CRUD) { Aurita.user.may(:edit_newsletter_subscribers) } 

    after(:perform_add, :perform_delete, :perform_update) { |controller|
      controller.redirect_to(:blank)
      controller.redirect(:element => :newsletter_subscriber_groups_box_body, :to => :edit_box_body)
    }

    def add
      Page.new(:header => tl(:add_subscriber_group)) { super() } 
    end
    def update
      Page.new(:header => tl(:edit_subscriber_group)) { super() } 
    end
    def delete
      Page.new(:header => tl(:delete_subscriber_group)) { super() } 
    end

    def edit_box
      return unless Aurita.user.may(:edit_newsletter_subscribers)
      
      box         = Box.new(:id => :newsletter_subscriber_groups_box, :class => :topic)
      box.header  = tl(:newsletter_subscriber_groups)
      box.body    = edit_box_body
      box.toolbar = [ 
        GUI::Toolbar_Button.new(:icon   => :add, 
                                :action => 'Mailing::Newsletter_Subscriber_Group/add', 
                                :label  => tl(:add_subscriber_group)).string
      ]
      box
    end
    def edit_box_body
      entries = Newsletter_Subscriber_Group.find(:all).sort_by(:group_name, :asc).to_a
      HTML.ul.no_bullets { 
        entries.map { |n|
          HTML.li.entity { 
            Context_Menu_Element.new(n) { 
              link_to(n, :action => :delete) { Icon.new(:delete).string }  + 
              link_to(n, :action => :update) { n.group_name } 
            }
          }
        }
      }
    end

  end

end
end
end

