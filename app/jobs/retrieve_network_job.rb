class RetrieveNetworkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # response = retrieve_citybike_networks
    # parse_response response
  end

  private 
  
  def retrieve_citybike_networks
    HTTParty.get('http://api.citybik.es/v2/networks')
  end
  
  def parse_response response
    code = response.code
    body = response.parsed_response
    Rails::logger.debug "hey"

    populate_data networks
  end

  def populate_data networks
    location = network['location']

    company_data = network['company']
    company_name = ''

    if company_data.kind_of?(Array)
      company_name = network['company']&.join(', ')
    elsif company_data.kind_of?(String)
      company_name = company_data
    end

    networks.each { |network|
      Rails::logger.debug "hey"
      Rails::logger.debug network["id"]
      # n = Network.new(city: location['city'],
      #                company_name: company_name,
      #                country: location['country'],
      #                latitude: location['latitude'],
      #                longitude: location['longitude'],
      #                name: network.name
      #               )
      # n.id = network['id']
    }
  end
end

