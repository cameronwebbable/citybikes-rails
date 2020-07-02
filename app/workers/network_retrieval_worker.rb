class NetworkRetrievalWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    response = retrieve_citybike_networks

  end

  def retrieve_citybike_networks
    HTTParty.get('http://api.citybik.es/v2/networks')
  end
end
