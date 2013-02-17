class AddTokensColumnsToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :auth_token, :string
    add_column :authentications, :auth_secret, :string
  end
end
