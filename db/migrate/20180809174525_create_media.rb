class CreateMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :media do |t|
      t.references :card, foreign_key: true, index: true
      t.string :category
      t.string :url
      t.timestamps
    end
  end
end
