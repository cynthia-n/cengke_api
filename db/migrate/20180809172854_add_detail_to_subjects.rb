class AddDetailToSubjects < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :detail, :string
    add_column :subjects, :crowd, :string
    add_column :subjects, :fee, :decimal, precision: 20, scale: 2
    add_column :subjects, :origin_fee, :decimal, precision: 20, scale: 2
  end
end
