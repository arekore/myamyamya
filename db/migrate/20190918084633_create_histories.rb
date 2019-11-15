class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.string :title
      t.string :video_id
      t.date :date
      t.text :comment
      t.integer :flag

      t.timestamps
    end
  end
end
