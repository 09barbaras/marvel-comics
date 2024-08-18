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
require 'rails_helper'

RSpec.describe FavoriteComic, type: :model do
  describe 'validations' do
    context 'when the comic_id is not present' do
      it 'is not valid' do
        favorite_comic = build(:favorite_comic, comic_id: nil)

        expect(favorite_comic).not_to be_valid
        expect(favorite_comic.errors[:comic_id]).to include("can't be blank")
      end
    end

    context 'when the user is not present' do
      it 'is not valid' do
        favorite_comic = build(:favorite_comic, user: nil)

        expect(favorite_comic).not_to be_valid
        expect(favorite_comic.errors[:user]).to include('must exist')
      end
    end

    context 'when the comic_id and user are present' do
      it 'is valid' do
        favorite_comic = build(:favorite_comic)

        expect(favorite_comic).to be_valid
      end
    end
  end
end
