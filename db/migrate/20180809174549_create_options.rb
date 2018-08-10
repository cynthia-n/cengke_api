class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.references :question, foreign_key: true, index: true
      t.string :title
      t.boolean :is_correct
      t.timestamps
    end
  end
end
