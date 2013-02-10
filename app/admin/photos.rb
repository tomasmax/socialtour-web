ActiveAdmin.register Photo do
  menu priority: 4, label: "Fotos"
  
  index do  
    column :id  
    column :poi
    column :user
    column :image do |photo|
      image_tag photo.image.url(:thumb)
    end  

    column :created_at
    
    default_actions
  end 
  
  form html: { enctype: "multipart/form-data" } do |f|
     f.inputs "Photo" do
      f.input :poi
      f.input :user
      f.input :image, :as => :file
      f.input :is_visible_on_index
      f.input :sequence
      f.input :title
      f.input :title_eu
      f.input :subtitle
      f.input :subtitle_eu
    end
    f.buttons
  end
  
  show do
    attributes_table do
      row :id
      row :poi
      row :user
      row :is_visible_on_index
      row :sequence
      row :image_file_name
      row :image_file_size

      row :created_at 
    end
    
    attributes_table do
      row :photo do |p|
        image_tag p.image(:full)
      end
    end
  end
end
