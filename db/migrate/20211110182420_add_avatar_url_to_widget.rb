class AddAvatarUrlToWidget < ActiveRecord::Migration[6.1]
  def change
    add_column :widgets, :avatar_url, :string
  end
end
