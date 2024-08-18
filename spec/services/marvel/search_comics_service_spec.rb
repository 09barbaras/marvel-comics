require 'rails_helper'
require 'ostruct'

RSpec.describe Marvel::SearchComicsService, type: :service do
  describe '#perform' do
    context 'when character is not present' do
      it 'returns unfiltered comics' do
        api_service_instance = instance_double(
          Marvel::ApiService,
          get_comics: OpenStruct.new({ body: { data: { results: [{
            id: 'comic_id_1',
            title: 'Comic Title',
            thumbnail: { path: 'http://example.com/cover', extension: 'jpg' }
          }] } }.to_json })
        )
        allow(Marvel::ApiService).to receive(:new).and_return(api_service_instance)

        expect(api_service_instance).to receive(:get_comics).with(1, 15, nil)
        expect(api_service_instance).not_to receive(:get_characters_by_name)

        result = described_class.perform(1, 15)

        expect(result.size).to eq(1)
        expect(result.first).to be_a(Comic)
      end
    end

    context 'when character is present' do
      it 'returns comics filtered by character' do
        api_service_instance = instance_double(
          Marvel::ApiService,
          get_comics: OpenStruct.new({ body: { data: { results: [{
            id: 'comic_id_2',
            title: 'Deadpool Comic',
            thumbnail: { path: 'http://example.com/cover', extension: 'jpg' }
          }] } }.to_json }),
          get_characters_by_name: OpenStruct.new({ body: { data: { results: [{ id: 'deadpool_id' }] } }.to_json })
        )
        allow(Marvel::ApiService).to receive(:new).and_return(api_service_instance)

        expect(api_service_instance).to receive(:get_characters_by_name).with('deadpool')
        expect(api_service_instance).to receive(:get_comics).with(1, 15, ['deadpool_id'])

        result = described_class.perform(1, 15, 'deadpool')

        expect(result.size).to eq(1)
        expect(result.first).to be_a(Comic)
      end
    end

    describe '#parse_comics' do
      it 'returns parsed comics' do
        comic_data = {
          'id' => 'comic_id_1',
          'title' => 'Comic Title',
          'thumbnail' => { 'path' => 'http://example.com/cover', 'extension' => 'jpg' }
        }
        result = described_class.new.send(:parse_comics, [comic_data])

        expected_comic = Comic.new(id: 'comic_id_1', title: 'COMIC TITLE', thumbnail: 'http://example.com/cover.jpg')
        expect(result.first).to be_a(Comic)
        expect(result.first).to have_attributes(
          id: expected_comic.id,
          title: expected_comic.title,
          thumbnail: expected_comic.thumbnail
        )
      end
    end
  end
end
