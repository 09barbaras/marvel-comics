# == Schema Information
#
# Table name: favorite_comics
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  comic_id   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FavoriteComic < ApplicationRecord
  belongs_to :user

  validates :comic_id, :user, presence: true
end
