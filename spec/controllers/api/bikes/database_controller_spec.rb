require 'rails_helper'

RSpec.describe Api::Bikes::DatabaseController, type: :controller do
  describe 'database#index' do
    let(:zipfile) { Pathname.new('public/networks_test.zip') }
    let(:subject) { Api::Bikes::DatabaseController }
    before(:each) { remove_zipfile }
    after(:each) { remove_zipfile }    

    def create_zipfile
      File.write('public/networks_test.zip', '')
    end

    def remove_zipfile
      if zipfile.exist?
        zipfile.delete
      end
    end

    context 'no zip file exists' do
      it 'returns correct response & starts the job' do
        expect(RetrieveNetworkJob).to receive(:perform_later)
        get :index
        expect(response).to have_http_status(:accepted)

      end
    end
    context 'no zip but job is running' do
      it 'returns correct response & does nothing else' do
        allow_any_instance_of(subject).to receive(:job_running?).and_return(true)
        expect(RetrieveNetworkJob).not_to receive(:perform_later)
        get :index
        expect(response).to have_http_status(:accepted)
      end
    end
    context 'has existing zip file' do
      it 'returns zip file' do
        create_zipfile
        expect(RetrieveNetworkJob).not_to receive(:perform_later)
        allow_any_instance_of(subject).to receive(:job_running?).and_return(false)
        get :index
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/zip')
      end
    end
  end
end