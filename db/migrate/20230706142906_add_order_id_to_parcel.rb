class AddOrderIdToParcel < ActiveRecord::Migration[6.1]
  def change
    add_column :parcels, :order_id, :integer
  end
end
