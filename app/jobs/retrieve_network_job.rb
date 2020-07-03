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
    
    puts body["networks"].first
  end

  def generate_database citybike_networks, db_name
    db = SQLite3::Database.open db_name
    db.execute "CREATE TABLE IF NOT EXISTS \
                networks(id TEXT NOT NULL, \
                        city TEXT, \
                        country TEXT, \
                        latitude DECIMAL(10,6), \
                        longitude DECIMAL(10,6), \
                        company_name TEXT, \
                        name TEXT)"
  end  
end

