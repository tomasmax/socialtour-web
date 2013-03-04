ActiveAdmin.register SubcategoryFoursquare do
  menu parent: "Categories", label: "Subcategorias_Foursquare"

  index do  
    column :name
    column :category_foursquare

    
    default_actions
  end 
  
  form do |f|
     f.inputs "Category" do
      f.input :name

      f.input :category_foursquare
      f.input :description
    end
    f.buttons
  end
  
end