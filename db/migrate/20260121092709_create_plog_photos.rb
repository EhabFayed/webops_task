class CreatePlogPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :plog_photos do |t|
      t.references :plog, null: false, foreign_key: true
      t.string :alt_ar
      t.string :alt_en
      t.boolean :is_arabic
      t.timestamps
    end
  end
end
