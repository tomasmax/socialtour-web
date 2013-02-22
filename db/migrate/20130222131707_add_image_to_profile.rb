class AddImageToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :image_file_name, :string
    add_column :profiles, :image_content_type, :string
    add_column :profiles, :image_file_size, :integer
    add_column :profiles, :image_update_at, :date_time
  end
end
