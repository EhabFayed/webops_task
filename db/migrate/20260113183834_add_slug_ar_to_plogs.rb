class AddSlugArToPlogs < ActiveRecord::Migration[8.0]
  def change
    add_column :plogs, :slug_ar, :string

    add_index :plogs, :slug, unique: true
    add_index :plogs, :slug_ar, unique: true
  end
end
