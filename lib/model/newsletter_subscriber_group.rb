
require('aurita/model')

module Aurita
module Plugins
module Mailing

  class Newsletter_Subscriber_Group < Aurita::Model
    table :newsletter_subsc_group, :public
    primary_key :newsletter_subsc_group_id, :newsletter_subsc_group_id_seq

  end

end
end
end

