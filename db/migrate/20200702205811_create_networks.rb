class CreateNetworks < ActiveRecord::Migration[6.0]
  def change
    puts "#{Rails.env}"

    Network.connection.create_table :networks, id: false do |t|
      t.string :id, null: false
      t.string :city
      t.string :company_name
      t.string :country
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :name
    end
    Network.connection.add_index :networks, :id, unique: true
  end
end
