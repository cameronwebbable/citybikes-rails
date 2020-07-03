class Network < ApplicationRecord
  establish_connection "networks_#{Rails.env}".to_sym
end
