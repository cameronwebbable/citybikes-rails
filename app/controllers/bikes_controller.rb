class BikesController < ApplicationController
  def index
    @networks = Network.all
  end
end
