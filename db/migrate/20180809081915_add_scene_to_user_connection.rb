class AddSceneToUserConnection < ActiveRecord::Migration[5.1]
  def change
    add_column :user_connections, :scene, :string, comment: 'scene'
    add_column :user_connections, :share_ticket, :string, comment: 'share_ticket'
  end
end
