ActiveAdmin.register Category do
  menu priority: 9, label: "Categories"

  index do  
    column :id
    column :name
    column :slug
    column :supercategory
    column :group
    column :is_route
    
    default_actions
  end 
  
  form do |f|
     f.inputs "Category" do
      f.input :id
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
