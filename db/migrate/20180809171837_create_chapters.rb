class CreateChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chapters do |t|
      t.references :subject, foreign_key: true, index: true
      t.string :title
      t.decimal :fee, precision: 20, scale: 2
      t.decimal :origin_fee, precision: 20, scale: 2
      t.timestamps
    end
  end
end
