class AddShareKeyToShare < ActiveRecord::Migration[5.1]
  def change
    add_column :shares, :share_key, :string, index: true
  end
end
