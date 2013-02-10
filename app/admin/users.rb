ActiveAdmin.register User do
  menu priority: 6, label: "Usuarios"

  index do  
    column :name  
    column :email
    column :providers do |user|
      user.authentications.collect{|auth| auth.provider }.join(', ')
    end
    column :created_at
    
    default_actions
  end
end
