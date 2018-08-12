class CreateUserCards < ActiveRecord::Migration[5.1]
  def change
    create_table :user_cards do |t|
      t.references :user, foreign_key: true, index: true
      t.references :card, foreign_key: true, index: true
      t.integer :status
      t.datetime :unlock_at
      t.datetime :start_at
      t.datetime :finish_at
      t.timestamps
    end
  end
end
