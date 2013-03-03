ActiveAdmin.register Category do
  menu priority: 9, label: "Categorias"

  index do  
    column :name
    column :slug
    column :supercategory
    column :group
    column :is_route
    
    default_actions
  end 
  
  form do |f|
     f.inputs "Category" do
      f.input :name
      f.input :is_route
      f.input :group
      f.input :slug
      f.input :supercategory
      f.input :description
    end
    f.buttons
  end
  
end
