class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.references :card, foreign_key: true, index: true
      t.string :title
      t.string :category
      t.timestamps
    end
  end
end
