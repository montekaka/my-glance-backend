class AddColorsToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :primary_color, :string
    add_column :profiles, :secondary_color, :string
    add_column :profiles, :success_color, :string
    add_column :profiles, :danger_color, :string
    add_column :profiles, :warning_color, :string
    add_column :profiles, :info_color, :string
    add_column :profiles, :light_color, :string
    add_column :profiles, :dark_color, :string
  end
end
