ActiveAdmin.register City do
  menu parent: "Countries", label: "Ciudades"

  show do
    attributes_table do
      row :minube_id
      row :name
      row :name_eu
      row :photos do |city|
       image_tag city.image.url(:city)
      end
    end
  end

  form html: { :enctype => "multipart/form-data" } do |f|
    f.inputs "City" do
      f.input :minube_id
      f.input :name
      f.input :name_eu
      f.input :image, :as => :file
    end
    f.buttons
  end
  
end
