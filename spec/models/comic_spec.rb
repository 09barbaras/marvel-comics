require 'rails_helper'

RSpec.describe Comic, type: :model do
  describe '#favorite?' do
    context 'when the comic is favorited by the user' do
      it 'returns true' do
        user = create(:user)
        comic = build(:comic)
        create(:favorite_comic, user:, comic_id: comic.id)

        expect(comic.favorite?(user)).to be(true)
      end
    end

    context 'when the comic is not favorited by the user' do
      it 'returns false' do
        user = create(:user)
        comic = build(:comic)

        expect(comic.favorite?(user)).to be(false)
      end
    end
  end
end
