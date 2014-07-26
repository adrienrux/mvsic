require 'spec_helper'

describe Api::FestivalsController do

  before :each do
    @festivals = create_list(:festival, 3)
  end

  describe '#index' do
    it 'should return an array of festivals' do
      get :index

      results = JSON.parse(response.body)
      expect(results).to be_a(Array)
      expect(results.size == 3).to be_true
      expect(results[0].keys).to include('id', 'name', 'location', 'description', 'start_date', 'end_date', 'events')
    end
  end

  describe '#show' do
    it 'should return a festival\'s data' do
      festival = @festivals.first
      get :show, id: festival.id

      results = JSON.parse(response.body)
      expect(results['id']).to eq festival.id
      expect(results['name']).to eq festival.name
      expect(results['location']).to eq festival.location
      expect(results['description']).to eq festival.description
      expect(results['start_date']).to eq festival.start_date.to_s
      expect(results['end_date']).to eq festival.end_date.to_s
      expect(results['events']).to eq festival.events
    end
  end

end
