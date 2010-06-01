
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter

module Aurita
module Plugins
module Mailing

  class Newsletter_Delivery < Aurita::Model
    table :newsletter_delivery, :public
    primary_key :newsletter_delivery_id, :newsletter_delivery_id_seq

    hide_attribute :timestamp_created
    hide_attribute :status

    has_a Newsletter, :newsletter_id

    def subscriber_groups
      Newsletter_Subscriber_Group.all_with(Newsletter_Subscriber_Group.newsletter_subsc_group_id.in(subscriber_group_ids)).to_a
    end

=begin
    migration_up { 
      create_table(:newsletter_delivery) { 
        schema :public
        primary_key :newsletter_delivery_id, :newsletter_delivery_id_seq
        
        newsletter_id Type.integer,          :null => false
        timestamp_created Type.timestamp,    :null => false, :default => 'now()'
        subscriber_group_ids Type.integer[], :null => false, :default => []
      }
    }
    
    migration_down { 
      drop_table :newsletter_delivery
      drop_sequence :newsletter_delivery_id_seq
    }
=end
    
  end

end
end
end

