class CreateShares < ActiveRecord::Migration[5.1]
  def change
    create_table :shares, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true, index: true
      t.references :source, polymorphic: true, index: true
      t.timestamps
    end
  end
end
