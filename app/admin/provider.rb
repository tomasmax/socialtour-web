ActiveAdmin.register Provider do
  menu priority: 8, label: "Proveedores"

  index do  
    column :name
    column :description
    column :city
    column :category
    column :supercategory
    
    default_actions
  end 
  
  form do |f|
     f.inputs "Category" do
      f.input :name
      f.input :description
      f.input :city
      f.input :category
      f.input :supercategory
    end
    f.buttons
  end
  
end