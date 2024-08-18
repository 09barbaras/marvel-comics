require 'rails_helper'

RSpec.describe Marvel::ApiService, type: :service do
  describe '#get_comics' do
    context 'when characters are not provided' do
      it 'calls marvel api with expected query params' do
        response = instance_double(Faraday::Response, body: { data: { results: [] } }.to_json)
        service = described_class.new
        connection = service.instance_variable_get(:@connection)
        allow(connection).to receive(:get).and_return(response)
        page = 1
        page_size = 15

        expect(connection).to receive(:get).with(
          '/v1/public/comics', {
            ts: anything,
            apikey: anything,
            hash: anything,
            offset: (page - 1) * page_size,
            limit: page_size,
            format: 'comic',
            formatType: 'comic',
            noVariants: true,
            orderBy: '-focDate'
          }
        )

        service.get_comics(page, page_size)
      end
    end

    context 'when characters are provided' do
      it 'characters param is included in the query params' do
        response = instance_double(Faraday::Response, body: { data: { results: [] } }.to_json)
        service = described_class.new
        connection = service.instance_variable_get(:@connection)
        allow(connection).to receive(:get).and_return(response)
        page = 2
        page_size = 15
        characters = ['deadpool_id']

        expect(connection).to receive(:get).with(
          '/v1/public/comics', {
            ts: anything,
            apikey: anything,
            hash: anything,
            offset: (page - 1) * page_size,
            limit: page_size,
            format: 'comic',
            formatType: 'comic',
            noVariants: true,
            orderBy: '-focDate',
            characters:
          }
        )

        service.get_comics(page, page_size, characters)
      end
    end
  end

  describe '#get_characters_by_name' do
    it 'calls characters endpoint' do
      response = instance_double(Faraday::Response, body: { data: { results: [] } }.to_json)
      service = described_class.new
      connection = service.instance_variable_get(:@connection)
      allow(connection).to receive(:get).and_return(response)
      character_name = 'deadpool'

      expect(connection).to receive(:get).with(
        '/v1/public/characters', {
          ts: anything,
          apikey: anything,
          hash: anything,
          name: character_name
        }
      )

      service.get_characters_by_name(character_name)
    end
  end
end
