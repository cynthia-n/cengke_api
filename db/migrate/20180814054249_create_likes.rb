class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, index: true
      t.references :source, polymorphic: true, index: true
      t.timestamps
    end
  end
end
