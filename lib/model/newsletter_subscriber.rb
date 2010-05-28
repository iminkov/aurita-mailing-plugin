
require('aurita/model')
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class Newsletter_Subscriber < Aurita::Model
    table :newsletter_subscriber, :public
    primary_key :newsletter_subscriber_id, :newsletter_subscriber_id_seq

    def subscriber_groups
      Newsletter_Subscriber_Group.all_with(:newsletter_subsc_group_id.in(subscriber_group_ids)).to_a
    end
    alias groups subscriber_groups

    def label
      "#{surname}, #{forename}"
    end

  end

end
end
end

