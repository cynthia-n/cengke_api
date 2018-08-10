class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, options: 'ROW_FORMAT=DYNAMIC'  do |t|
      t.string :nickname, comment: '名称'
      t.string :avatar, comment: '头像'
      t.string :wechat_unionid, comment: '微信unionid'
      t.string :token, comment: 'token'
      t.datetime :last_sign_in_at, comment: '最后一次登录时间'
      t.string :last_sign_in_ip, comment: '最后一次登录ip'
      t.index ["token"], name: "index_users_on_token", unique: true, using: :btree
      t.timestamps
    end
  end
end
