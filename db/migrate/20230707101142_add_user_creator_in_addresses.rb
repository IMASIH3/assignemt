class AddUserCreatorInAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :user_creator, :integer
  end
end
