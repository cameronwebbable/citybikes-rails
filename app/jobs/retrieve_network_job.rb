class RetrieveNetworkJob < ApplicationJob
  queue_as :network

  def perform(*args)
    retrieve_citybike_networks
  end

  private 
  
  def retrieve_citybike_networks
    response = HTTParty.get('http://api.citybik.es/v2/networks')
    
    return unless response.success?

    parsed_response = response.parsed_response
    
    if parsed_response.key? 'networks'
      load_networks parsed_response['networks']
      zip_networks_db
    end
  end

  def load_networks networks
    mapped_networks = networks.map { |network|
      location = network['location']

      company_data = network['company']
      company_name = ''

      if company_data.kind_of?(Array)
        company_name = network['company'].join(', ')
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
    
    Network.upsert_all(mapped_networks, unique_by: :id)
  end

  def zip_networks_db
    folder = 'db'
    filename = "networks_#{Rails.env}.sqlite3"

    zipfile_name = "public/networks_#{Rails.env}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      zipfile.add(filename, File.join(folder, filename))
    end
  end
end

