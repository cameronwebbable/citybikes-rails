class RetrieveNetworkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    response = retrieve_citybike_networks
    load_networks response
  end

  private 
  
  def retrieve_citybike_networks
    HTTParty.get('http://api.citybik.es/v2/networks')
  end
  
  def load_networks response
    code = response.code
    parsed_response = response.parsed_response
    
    # map attrs and use upsert
    populate_data body['networks']
  end

  def populate_data networks
    networks.each { |network|
      Rails::logger.debug network
      location = network['location']

      company_data = network['company']
      company_name = ''
  
      if company_data.kind_of?(Array)
        company_name = network['company']&.join(', ')
      elsif company_data.kind_of?(String)
        company_name = company_data
      end

      network_attr = 
      n = Network.create(id: network['id'],
                         city: location['city'],
                         company_name: company_name,
                         country: location['country'],
                         latitude: location['latitude'],
                         longitude: location['longitude'],
                         name: network['name']
                        )
    }

  end
end

