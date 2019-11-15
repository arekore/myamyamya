class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :thumbnail
      t.string :video_id
      t.string :status
      t.datetime :start_time

      t.timestamps
    end
  end
end
