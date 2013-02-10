class AddColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :minube_id, :integer
    add_column :cities, :slug, :string
    add_column :cities, :image_file_name, :string
    add_column :cities, :image_content_type, :string
    add_column :cities, :image_file_size, :integer
    add_column :cities, :image_upload_at, :datetime
    add_column :cities, :name_eu, :string
  end
end
