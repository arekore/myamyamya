class CreateMostViewMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :most_view_movies do |t|
      t.string :title
      t.string :video_id
      t.string :thumbnail
      t.datetime :start_date
      t.integer :rank

      t.timestamps
    end
  end
end
