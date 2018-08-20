class AddFailToCengke < ActiveRecord::Migration[5.1]
  def change
    add_column :cengkes, :fail, :boolean
    add_column :cengkes, :error, :string
  end
end
