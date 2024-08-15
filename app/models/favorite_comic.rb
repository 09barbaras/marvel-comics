class FavoriteComic < ApplicationRecord
  belongs_to :user
  
  validates :comic_id, :user, presence: true
end
