class AddDurationToMedium < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :duration, :integer
  end
end
