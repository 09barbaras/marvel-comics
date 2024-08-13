class ComicsController < ApplicationController
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
end