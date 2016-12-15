class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :title
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :entries, [:user_id, :created_at]
  end
end
