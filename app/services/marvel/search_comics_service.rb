module Marvel
  class SearchComicsService
    def self.perform(*args)
      new.perform(*args)
    end

    def perform(page, page_size, character = nil)
      characters = get_cached_characters(character)
      data = get_cached_comics(page, page_size, character, characters)

      parse_comics(data)
    end

    private

    def get_cached_characters(character)
      return nil unless character.present?

      Rails.cache.fetch(characters_cache_key(character), expires_in: 12.hours) do
        characters_response = ApiService.new.get_characters_by_name(character)
        return nil unless characters_response.present?

        characters_response.body['data']['results'].map { |c| c['id'] }
      end
    end

    def get_cached_comics(page, page_size, character, characters)
      Rails.cache.fetch(comics_cache_key(page, page_size, character), expires_in: 12.hours) do
        response = ApiService.new.get_comics(page, page_size, characters)
        return [] unless response.present?

        response.body['data']['results']
      end
    end

    def comics_cache_key(page, page_size, character)
      "comics_page_#{page}_size_#{page_size}#{character.present? ? "_character_#{character}" : ''}"
    end

    def characters_cache_key(name)
      "characters_#{name}"
    end

    def parse_comics(results)
      results.map do |comic_data|
        Comic.new(
          id: comic_data['id'],
          title: comic_data['title']&.upcase,
          thumbnail: "#{comic_data['thumbnail']['path']}.#{comic_data['thumbnail']['extension']}"
        ).freeze
      end
    end

    def cached_response(response, cache_key, etag_cache_key)
      return [] unless response.present?

      case response.status
      when 304
        Rails.cache.read(cache_key)
      when 200
        Rails.cache.write(etag_cache_key, response.headers['etag'])
        Rails.cache.write(cache_key, response.body['data']['results'])
        response.body['data']['results']
      else
        []
      end
    end
  end
end
