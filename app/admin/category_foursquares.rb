ActiveAdmin.register CategoryFoursquare do
  menu parent: "Categories", label: "Categorias_Foursquare"

  index do  
    column :name
    column :supercategory_foursquare

    
    default_actions
  end 
  
  form do |f|
     f.inputs "Category" do
      f.input :name

      f.input :supercategory_foursquare
      f.input :description
    end
    f.buttons
  end
  
end