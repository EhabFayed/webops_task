class CreateContent < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.text :content_ar
      t.text :content_en
      t.integer :plog_id
      t.integer :user_id
      t.timestamps
    end
  end
end
