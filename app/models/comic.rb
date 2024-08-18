class Comic
  include ActiveModel::API
  include ActiveModel::Attributes

  # ID of the comic from Marvel API
  attribute :id, :string
  attribute :title, :string
  attribute :thumbnail, :string
  validates :id, :title, :thumbnail, presence: true

  def favorite?(user)
    FavoriteComic.find_by(user:, comic_id: id).present?
  end
end
