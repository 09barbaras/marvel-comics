require 'rails_helper'

RSpec.describe ComicsController, type: :request do
  describe '#index' do
    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get comics_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      it 'returns 200' do
        stub_request(:get, /gateway.marvel.com/).to_return(
          status: 200,
          body: { data: { results: [{
            id: 'comic_id_1',
            title: 'Comic Title',
            thumbnail: { path: 'http://example.com/cover', extension: 'jpg' }
          }] } }.to_json
        )

        user = create(:user)
        sign_in user
        get comics_path

        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#toggle_favorite' do
    context 'when comic is not favorite' do
      it 'creates favorite and redirects to comics' do
        user = create(:user)
        sign_in user

        post favorite_comic_path('comic_id')

        expect(FavoriteComic.find_by(user:, comic_id: 'comic_id')).to be_present
        expect(response).to redirect_to(comics_path)
      end
    end

    context 'when comic is favorite' do
      it 'removes favorite and redirects to comics' do
        user = create(:user)
        create(:favorite_comic, user:, comic_id: 'comic_id')
        sign_in user

        post favorite_comic_path('comic_id')

        expect(FavoriteComic.find_by(user:, comic_id: 'comic_id')).to be_nil
        expect(response).to redirect_to(comics_path)
      end
    end
  end
end
