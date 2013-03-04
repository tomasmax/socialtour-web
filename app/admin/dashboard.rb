ActiveAdmin.register_page "Dashboard" do

  
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
       
    panel "Ultimos POIs" do
      table_for Poi.order("created_at desc").limit(5) do  
        column :name do |poi|  
          link_to poi.name, admin_poi_path(poi) if poi
        end
        column :city
        column :user
      end  
      strong { link_to "Ver todos", admin_pois_path } 
    end
    
    panel "Ultimos usuarios" do  
      table_for User.order("created_at desc").limit(5) do  
        column :name do |user|
          link_to user.name, admin_user_path(user)
        end
        column :provider do |user|
          user.authentications.pluck(:provider).join(',')
        end 
      end  
      strong { link_to "Ver todos", admin_users_path }  
  end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
  
end
