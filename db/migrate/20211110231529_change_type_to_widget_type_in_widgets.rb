class ChangeTypeToWidgetTypeInWidgets < ActiveRecord::Migration[6.1]
  def change
    rename_column :widgets, :type, :widget_type
  end
end
