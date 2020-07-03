class CreateNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :networks do |t|
      t.string :city
      t.string :citybike_id
      t.string :company_name
      t.string :country
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :name

      t.timestamps
    end
    add_index :networks, :citybike_id, unique: true
  end
end

"CREATE TABLE IF NOT EXISTS networks(id TEXT NOT NULL, city TEXT, country TEXT, latitude DECIMAL(10,6), longitude DECIMAL(10,6), company_name TEXT, name TEXT)"

"CREATE UNIQUE INDEX idx_unique_id on networks (id)"

"CREATE TABLE IF NOT EXISTS networks(id TEXT unique)"

"INSERT INTO networks (id, city, country, latitude, longitude, company_name, name) VALUES (?,?,?,?,?,?,?)", 1,'a','b',1.0,1.0,'a','a'