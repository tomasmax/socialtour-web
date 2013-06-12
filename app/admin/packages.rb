ActiveAdmin.register Package do
  menu priority: 7, label: "Paquetes turisticos"

  index do
    
    column :name
    column :pois
    column :description
    column :price
    column :category
    column :supercategory
    column :type
    column :user
    column :provider
    
    default_actions
  end 
  
  form do |f|
     f.inputs "Package" do
      f.input :name
      f.input :pois
      f.input :description
      f.input :price
      f.input :category
      f.input :supercategory
      f.input :type
      f.input :user
      f.input :provider
    end
    f.buttons
  end
  
end