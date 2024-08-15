class CreateFavoriteComics < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_comics do |t|
      t.references :user, null: false, foreign_key: true
      t.string :comic_id, null: false

      t.timestamps
    end
  end
end
