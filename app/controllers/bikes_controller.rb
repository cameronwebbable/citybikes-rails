class BikesController < ApplicationController
  def index
    @networks = Network.all

    respond_to do |format|
      format.html
      format.json { render json: @networks }
    end

  end
end
