class Comic
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :title, :string
  attribute :thumbnail, :string
  validates :id, :title, :thumbnail, presence: true

  def self.from_api_response(results)
    results.map do |comic_data|
      Comic.new(
        id: comic_data["id"],
        title: comic_data["title"]&.upcase,
        thumbnail: "#{comic_data['thumbnail']['path']}.#{comic_data['thumbnail']['extension']}"
      ).freeze
    end
  end

  def favorite?(user)
    FavoriteComic.find_by(user: user, comic_id: id).present?
  end
end
