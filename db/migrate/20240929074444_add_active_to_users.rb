class AddActiveToUsers < ActiveRecord::Migration[7.2]
  def change
    # 'active' カラムが既に存在する場合はスキップ
    unless column_exists?(:users, :active)
      add_column :users, :active, :boolean
    end
  end
end
