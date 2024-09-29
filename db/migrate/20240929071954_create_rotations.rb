class CreateRotations < ActiveRecord::Migration[7.0]
  def change
    create_table :rotations do |t|
      t.references :current_user, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
  end
end

