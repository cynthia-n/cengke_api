class CreateUserConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :user_connections, options: 'ROW_FORMAT=DYNAMIC'  do |t|
      t.references :user, foreign_key: true, comment: '用户ID', index: true
      t.string :platform, comment: '授权平台'
      t.string :unionid, comment: 'unionid'
      t.string :openid, comment: 'openid'
      t.string :access_token, comment: '授权token'
      t.datetime :last_auth_at, comment: '最后一次授权时间'
      t.text :info, comment: '详细信息'
      t.timestamps
    end
  end
end
