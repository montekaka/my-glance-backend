class AddShowThumbnailToWidgets < ActiveRecord::Migration[6.1]
  def change
    add_column :widgets, :show_thumbnail, :boolean
  end
end
