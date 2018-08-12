class AddLikeShareBaseCountToSubjectCard < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :learning_base_count, :integer
    add_column :cards, :like_base_count, :integer
    add_column :cards, :share_base_count, :integer
  end
end
