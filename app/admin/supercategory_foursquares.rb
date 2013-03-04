ActiveAdmin.register SupercategoryFoursquare do
  menu parent: "Supercategories", label: "Supercategorias_Foursquare"

  index do
    column :id
    column :name
    
    default_actions
  end 
  
  form do |f|
     f.inputs "Supercategory Foursquare" do
      f.input :name
      f.input :icon, :as => :file
    end
    f.buttons
  end
  
end