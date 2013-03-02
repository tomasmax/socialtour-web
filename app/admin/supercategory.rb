ActiveAdmin.register Supercategory do
  menu parent: "Categorias", label: "Supercategorias"

  index do
    column :id
    column :name
    column :slug
    column :icon do |sc|
      image_tag sc.icon.url(:med)
    end
    default_actions
  end 
  
  form :html => { :enctype => "multipart/form-data" } do |f|
     f.inputs "Supercategory" do
      f.input :name
      f.input :slug
      f.input :icon, :as => :file
    end
    f.buttons
  end
  
  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :icon_file_size

      row :icon do |sc|
        image_tag sc.icon(:big)
      end
    end
  end
end
