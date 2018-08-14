class CreateCengkes < ActiveRecord::Migration[5.1]
  def change
    create_table :cengkes do |t|
      t.references :user, foreign_key: true, index: true
      t.integer :source_user_id, index: true
      t.references :card, foreign_key: true, index: true
      t.boolean :is_new_friend
      t.timestamps
    end
  end
end
