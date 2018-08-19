class AddRatio54UrlToMedia < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :ratio54_url, :string
  end
end
