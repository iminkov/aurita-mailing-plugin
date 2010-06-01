
require('aurita/plugin_controller')
Aurita.import_plugin_model :mailing, :newsletter_delivery
Aurita.import_plugin_model :mailing, :newsletter
Aurita.import_plugin_model :mailing, :newsletter_subscriber
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group
Aurita.import_plugin_module :mailing, :newsletter_renderer

module Aurita
module Plugins
module Mailing

  class Newsletter_Delivery_Controller < Aurita::Plugin_Controller

    guard(:CRUD) { Aurita.user.may(:edit_newsletters) } 

    after(:perform_add, :perform_update, :perform_delete) { |controller|
      controller.redirect_to(:schedule)
    }

    def form_groups
      [
        Newsletter_Delivery.newsletter_id, 
        Newsletter_Delivery.subscriber_group_ids
      ]
    end

    def add
      n = Newsletter.get(param(:newsletter_id))

      form = add_form()
      form.add(Hidden_Field.new(:name  => Newsletter_Delivery.newsletter_id, 
                                :value => n.newsletter_id))
      form.add(Entity_Selection_List_Field.new(:name  => Newsletter_Delivery.subscriber_group_ids.to_s, 
                                               :label => tl(:send_to_subscriber_groups), 
                                               :model => Newsletter_Subscriber_Group))

      Page.new(:header => tl(:send_newsletter)) { 
        decorate_form(form) + 
        
        Newsletter_Renderer.new(n).html_body
      }
    end

    def update
      instance = load_instance()

      form = update_form()
      form.add(Hidden_Field.new(:name  => Newsletter_Delivery.newsletter_id, 
                                :value => instance.newsletter_id))
      form.add(Entity_Selection_List_Field.new(:name  => Newsletter_Delivery.subscriber_group_ids.to_s, 
                                               :label => tl(:send_to_subscriber_groups), 
                                               :value => instance.subscriber_group_ids, 
                                               :model => Newsletter_Subscriber_Group))

      Page.new(:header => tl(:change_scheduled_delivery)) { 
        decorate_form(form)
      }
    end

    def schedule
      plan = Newsletter_Delivery.select { |nd|
        nd.join(Newsletter).using(:newsletter_id) { |n|
          n.where(:status => :scheduled)
          n.order_by(:timestamp_created, :asc)
        }
      }.to_a

      table = Table.new(:headers => [ '', tl(:newsletter), tl(:subscriber_groups), tl(:scheduled_at) ], 
                        :class   => :list)
      plan.each { |e|
        row   = []
        icons = []
        icons << link_to(:perform_delete, :newsletter_delivery_id => e.newsletter_delivery_id) { Icon.new(:delete).string }  
        icons << link_to(:update, :newsletter_delivery_id => e.newsletter_delivery_id) { Icon.new(:edit_button).string }  
        row << icons
        row << e.newsletter_name
        row << e.subscriber_groups.map { |sg| link_to(sg, :action => :update) { sg.group_name } }.join(', ')
        row << datetime(e.timestamp_created)
        table.add_row(row)
      }

      Page.new(:header => tl(:delivery_schedule)) {
        table
      }
    end

  end

end
end
end

