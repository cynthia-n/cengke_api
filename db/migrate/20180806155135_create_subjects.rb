class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects, options: 'ROW_FORMAT=DYNAMIC'  do |t|
      t.string :name, comment: '名称'
      t.string :introduction, comment: '简介'
      t.string :image_url, comment: '图片地址'
      t.string :remark, comment: '备注'
      t.integer :status, comment: '状态'
      t.string :display_size, comment: '展示大小'
      t.timestamps
    end
  end
end
