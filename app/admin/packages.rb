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
    f.input :type_leisure
    f.input :type_time
    f.input :type_vehicle
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
      f.input :type_leisure
      f.input :type_time
      f.input :type_vehicle
      f.input :user
      f.input :provider
    end
    f.buttons
  end
  
end