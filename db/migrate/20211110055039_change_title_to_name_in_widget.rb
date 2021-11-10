class ChangeTitleToNameInWidget < ActiveRecord::Migration[6.1]
  def change
    rename_column :widgets, :title, :name
  end
end
