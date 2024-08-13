require 'net/http'
require 'digest'

class MarvelApiService
  def initialize()
    @public_key = ENV["MARVEL_PUBLIC_KEY"].freeze
    @connection = Faraday.new(
      url: ENV["MARVEL_API_BASE_URL"],
      headers: {"Accept" => "*/*"}
    ) do |builder|
      # builder.request :retry, max: 3, interval: 0.05, interval_randomness: 0.5, backoff_factor: 2
      # Parses JSON response bodies. If not valid JSON, raises Faraday::ParsingError
      builder.response :json
      # Raises an error on 4xx and 5xx responses
      # builder.response :raise_error
      builder.response :logger
      builder.options.timeout = 120
      builder.options.open_timeout = 110
    end
  end

  def get_comics(page, page_size)
    ts = Time.now.to_i.to_s
    hash = generate_hash(ts)
    offset = (page.to_i - 1) * page_size
    cache_key = "comics_page_#{page}_size_#{page_size}"
    etag_cache_key = "#{cache_key}_etag"

    # Fetch the cached response and ETag
    response = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      etag = Rails.cache.read(etag_cache_key)
      headers = {"Accept" => "*/*"}
      headers['If-None-Match'] = etag if etag

      # TODO: handle slow response times
      response = @connection.get("/v1/public/comics", {
        ts: ts, 
        apikey: @public_key,
        hash: hash, 
        offset: offset, 
        limit: page_size,
        format: "comic",
        formatType: "comic",
        noVariants: true,
        orderBy: "-focDate"
      }, headers)

      if response.status == 304
        cached_response = Rails.cache.read(cache_key)
        return cached_response if cached_response
      else
        Rails.cache.write(etag_cache_key, response.headers["etag"], expires_in: 12.hours)
      end

      puts response.headers
      puts response.body
      response.body["data"]["results"]
    end
  
    response
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
    puts "Request failed: #{e.message}"
    # TODO: Handle the timeout or connection failure
  end

  private

  def generate_hash(ts)
    Digest::MD5.hexdigest("#{ts}#{ENV["MARVEL_PRIVATE_KEY"]}#{@public_key}")
  end
end