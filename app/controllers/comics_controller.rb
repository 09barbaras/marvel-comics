class ComicsController < ApplicationController
  before_action :authenticate_user!

  PAGE_SIZE = 15

  # Get comics from Marvel API page by page
  def index
    # TODO: Handle search by character

    page = params[:page] || 1
    results = MarvelApiService.new.get_comics(page, PAGE_SIZE)
    @comics = Comic.from_api_response(results)
    @current_page = page.to_i
    @next_page = @current_page + 1
    @prev_page = @current_page > 1 ? @current_page - 1 : nil
  end

  def toggle_favorite
    comic_id = params[:id]
    favorite = FavoriteComic.find_by(user: current_user, comic_id: comic_id)
    favorite.present? ? favorite.destroy : FavoriteComic.create(user: current_user, comic_id: comic_id)

    redirect_to comics_path(page: params[:page])
  end
end