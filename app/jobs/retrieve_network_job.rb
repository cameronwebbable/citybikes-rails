class RetrieveNetworkJob < ApplicationJob
  queue_as :default

  def perform(*args)
    response = retrieve_citybike_networks
    parse_response response
  end

  private 
  
  def retrieve_citybike_networks
    HTTParty.get('http://api.citybik.es/v2/networks')
  end
  
  def parse_response response
    code = response.code
    body = response.parsed_response
    
    generate_database body["networks"]
    puts body["networks"].first
  end

  def generate_database citybike_networks, db_name="public/networks.db"
    db = SQLite3::Database.open db_name
    db.execute "CREATE TABLE IF NOT EXISTS \
                networks(id TEXT NOT NULL, \
                        city TEXT, \
                        country TEXT, \
                        latitude DECIMAL(10,6), \
                        longitude DECIMAL(10,6), \
                        company_name TEXT, \
                        name TEXT)"

    db.execute "CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_id on networks (id)"
    
    citybike_networks.each_with_index { |network, idx| 
      location = network['location']

      company_data = network['company']
      company_name = ''

      if company_data.kind_of?(Array)
        company_name = network['company']&.join(', ')
      elsif company_data.kind_of?(String)
        company_name = company_data
      end

      db.execute "INSERT INTO networks \
                  (id, city, country, latitude, longitude, company_name, name) \
                  VALUES (?,?,?,?,?,?,?)", 
                  network['id'],location['city'],location['country'],location['latitude'],
                  location['longitude'],company_name ,network['name']
    }
  end  
end

