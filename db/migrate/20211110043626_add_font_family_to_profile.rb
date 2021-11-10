class AddFontFamilyToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :font_family, :string
  end
end
