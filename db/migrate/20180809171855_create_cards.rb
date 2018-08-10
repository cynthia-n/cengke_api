class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.references :chapter, foreign_key: true, index: true
      t.string :title
      t.text :content
      t.boolean :is_free
      t.timestamps
    end
  end
end
