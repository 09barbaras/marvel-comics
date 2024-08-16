require 'net/http'
require 'digest'

module Marvel
  class ApiService
    def initialize()
      @public_key = ENV["MARVEL_PUBLIC_KEY"].freeze
      @connection = Faraday.new(
        url: ENV["MARVEL_API_BASE_URL"],
        headers: {"Accept" => "*/*"}
      ) do |builder|
        # Parses JSON response bodies. If not valid JSON, raises Faraday::ParsingError
        builder.response :json
        # Raises an error on 4xx and 5xx responses
        builder.response :raise_error
        builder.response :logger
        builder.options.timeout = 120
        builder.options.open_timeout = 110
      end
    end

    def get_comics(page, page_size, characters = nil)
      offset = (page.to_i - 1) * page_size

      query_params = {
        ts: ts, 
        apikey: @public_key,
        hash: generate_hash, 
        offset: offset, 
        limit: page_size,
        format: "comic",
        formatType: "comic",
        noVariants: true,
        orderBy: "-focDate"
      }
      query_params[:characters] = characters if characters

      @connection.get("/v1/public/comics", query_params)
    rescue => e
      puts "GET /comics failed: #{e.message}"
      nil
    end

    def get_characters_by_name(name)
      query_params = {
        ts: ts, 
        apikey: @public_key,
        hash: generate_hash, 
        name: name
      }

      @connection.get("/v1/public/characters", query_params)
    rescue => e
      puts "GET /characters failed: #{e.message}"
      nil
    end

    private

    def generate_hash
      Digest::MD5.hexdigest("#{ts}#{ENV["MARVEL_PRIVATE_KEY"]}#{@public_key}")
    end

    def ts
      Time.now.to_i.to_s
    end
  end
end