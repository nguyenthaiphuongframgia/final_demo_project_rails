class AddPictureToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :picture, :string
  end
end
