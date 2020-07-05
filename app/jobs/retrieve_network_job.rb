class RetrieveNetworkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    handle_response retrieve_citybike_networks
  end

  private 
  
  def retrieve_citybike_networks
    HTTParty.get('http://api.citybik.es/v2/networks')
  end
  
  def handle_response response
    code = response.code
    parsed_response = response.parsed_response
    
    if parsed_response.key? 'networks'
      load_networks parsed_response['networks']
    end
  end

  def load_networks networks
    mapped_networks = networks.map { |network|

      location = network['location']

      company_data = network['company']
      company_name = ''

      if company_data.kind_of?(Array)
        company_name = network['company']&.join(', ')
      elsif company_data.kind_of?(String)
        company_name = company_data
      end

      {
        id: network['id'],
        city: location['city'],
        company_name: company_name,
        country: location['country'],
        latitude: location['latitude'],
        longitude: location['longitude'],
        name: network['name'] 
      }
    }

    Network.upsert_all(mapped_networks, unique_by: [:id])
  end
end

