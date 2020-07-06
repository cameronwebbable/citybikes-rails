class Api::Bikes::DatabaseController < Api::ApiController
  def index
    if zip_exists?
      return send_data zip_path, type: 'application/zip', filename: 'networks.zip'
    elsif job_running?
      return render json: {}, status: :accepted
    end

    RetrieveNetworkJob.perform_later
    render json: {}, status: :accepted
  end

  private
  
  def zip_path
    "public/networks_#{Rails.env}.zip"
  end

  def zip_exists?
    Pathname.new(zip_path).exist?
  end

  def job_running?
    still_running = false
    workers = Sidekiq::Workers.new

    workers.each { |pid, tid, work|
      if work['queue'] == 'network'
        still_running = true
        break
      end
    }

    still_running
  end
end
