ActiveAdmin.register Country do
  menu priority: 2, label: "Paises"

  show do
    attributes_table do
      row :minube_id
      row :name
    end
  end

  form html: { :enctype => "multipart/form-data" } do |f|
    f.inputs "City" do
      f.input :minube_id
      f.input :name
     
    end
    f.buttons
  end
  
end