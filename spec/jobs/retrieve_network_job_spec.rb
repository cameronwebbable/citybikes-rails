require 'rails_helper'

RSpec.describe RetrieveNetworkJob, type: :job do
  let(:response) { JSON.parse(File.read('spec/jobs/fixtures/citybikes_response.json'))}

  describe 'perform now' do
    let(:citybike_response) { instance_double(HTTParty::Response, code: 200, parsed_response: response) }

    before(:each) do
      allow(HTTParty).to receive(:get).and_return(citybike_response)
    end

    context 'parsing' do
      it 'produces the correct amount of Networks' do
        actual_count = response['networks'].count
        RetrieveNetworkJob.perform_now
        networks_count = Network.count

        expect(networks_count).to eq(actual_count)
      end
    end
  end
end

