class AddSortOrderToSocialNetworks < ActiveRecord::Migration[6.1]
  def change
    add_column :social_networks, :sort_order, :integer
  end
end
