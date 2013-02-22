class AddImageToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :image_file_name, :string
    add_column :providers, :image_content_type, :string
    add_column :providers, :image_file_size, :integer
    add_column :providers, :image_update_at, :date_time
  end
end
