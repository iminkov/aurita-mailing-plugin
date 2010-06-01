
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
        Newsletter_Subscriber.email, 
        Newsletter_Subscriber.forename, 
        Newsletter_Subscriber.surname, 
        :subscriber_group_ids 
      ]
    end

    def add
      form         = add_form()
      group_select = Entity_Selection_List_Field.new(:name  => :subscriber_group_ids, 
                                                     :label => tl(:subscriber_groups), 
                                                     :model => Newsletter_Subscriber_Group)
      form[:subscriber_group_ids] = group_select

      Page.new(:header => tl(:add_subscriber)) { decorate_form(form) } 
    end

    def update
      instance     = load_instance()
      form         = update_form()
      group_select = Entity_Selection_List_Field.new(:name  => :subscriber_group_ids, 
                                                     :label => tl(:subscriber_groups), 
                                                     :value => instance.subscriber_group_ids, 
                                                     :model => Newsletter_Subscriber_Group)
      form[:subscriber_group_ids] = group_select

      Page.new(:header => tl(:edit_subscriber)) { decorate_form(form) } 
    end

    def perform_update
      super()
    end

    after(:perform_add, :perform_delete, :perform_update) { |controller|
      controller.redirect_to(:blank)
      controller.redirect(:element => :newsletter_subscribers_box_body, :to => :edit_box_body)
    }

    def edit_box
      return unless Aurita.user.may(:edit_newsletter_subscribers)

      box         = Box.new(:id => :newsletter_subscribers_box, :class => :topic)
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
          HTML.li.entity { 
            Context_Menu_Element.new(n) { 
              link_to(n, :action => :delete) { Icon.new(:delete).string } + 
              HTML.div.label { link_to(n, :action => :update) { n.label } }
            }
          }
        }
      }
    end

  end

end
end
end

