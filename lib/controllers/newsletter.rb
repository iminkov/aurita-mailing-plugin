
require('aurita/plugin_controller')
Aurita.import_plugin_model :mailing, :newsletter
Aurita.import_plugin_model :mailing, :newsletter_subscriber
Aurita.import_plugin_model :mailing, :newsletter_subscriber_group

module Aurita
module Plugins
module Mailing

  class Newsletter_Controller < Aurita::Plugin_Controller

    guard(:CRUD) { Aurita.user.may(:edit_newsletters) } 

    after(:perform_add, :perform_delete, :perform_update) { |controller|
      controller.redirect_to(:blank)
      controller.redirect(:element => :newsletters_box_body, :to => :edit_box_body)
    }

    def add
      form = super
      return form unless param(:element) == 'app_main_content'

      Page.new(:header => tl(:add_newsletter)) { form }
    end
    def update
      form = super
      return form unless param(:element) == 'app_main_content'

      Page.new(:header => load_instance.newsletter_name) { form }
    end
    def delete
      form = super
      return form unless param(:element) == 'app_main_content'

      Page.new(:header => tl(:delete_newsletter)) { form }
    end

    def edit_box
      return unless Aurita.user.may(:edit_newsletters)

      box         = Box.new(:id => :newsletters_box, :class => :topic)
      box.header  = tl(:newsletters)
      box.body    = edit_box_body
      box.toolbar = [ 
        GUI::Toolbar_Button.new(:icon   => :add, 
                                :action => 'Mailing::Newsletter/add', 
                                :label  => tl(:add_newsletter)).string, 
        GUI::Toolbar_Button.new(:icon   => :plan, 
                                :action => 'Mailing::Newsletter_Delivery/schedule', 
                                :label  => tl(:delivery_schedule)).string
      ]
      box
    end
    def edit_box_body
      entries = Newsletter.find(:all).sort_by(:newsletter_name, :asc).to_a
      HTML.ul.no_bullets { 
        entries.map { |n|
          HTML.li.entity { 
            Context_Menu_Element.new(n) { 
              link_to(n, :action => :show, :newsletter_id => n.newsletter_id) { 
                Icon.new(:edit_button).string 
              } + 
              link_to(:controller    => 'Mailing::Newsletter_Delivery', 
                      :action        => :add, 
                      :newsletter_id => n.newsletter_id) { 
                Icon.new(:mailbox).string 
              } + 
              link_to(n, :action => :delete) { Icon.new(:delete).string } + 
              link_to(n, :action => :update) { n.newsletter_name }
            }
          }
        }
      }
    end

    def show
      n = load_instance()
      return unless n

      elements = n.elements.map { |p|
        if p.kind_of?(Wiki::Article) then
          Aurita::GUI::Text_Button.new(:class   => :remove_article_button, 
                                       :onclick => link_to(:controller    => 'Mailing::Newsletter_Element', 
                                                           :action        => :perform_delete, 
                                                           :newsletter_id => n.newsletter_id, 
                                                           :content_id    => p.content_id)) { tl(:remove_article) } + 
          render_controller(Wiki::Article_Controller, :show, :article_id => p.article_id)
        end
      }

      Page.new(:header => "#{tl(:newsletter)}: #{n.newsletter_name}") { 
        HTML.div.button_bar { 
          Aurita::GUI::Text_Button.new(:onclick => link_to(:controller => 'Mailing::Newsletter_Element', 
                                                   :action        => :add_article, 
                                                   :newsletter_id => n.newsletter_id, 
                                                   :element       => :form_section)) { 
            tl(:add_article) 
          } 
        } +
        HTML.div(:id => :form_section) { } + 
        HTML.div.newsletter { 
          elements
        }
      }
    end

  end

end
end
end

