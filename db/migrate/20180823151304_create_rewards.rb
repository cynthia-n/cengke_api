class CreateRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true, index: true
      t.references :chapter, foreign_key: true, index: true
      t.string :category
      t.integer :status
      t.timestamps
    end
  end
end
