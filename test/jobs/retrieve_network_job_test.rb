require 'test_helper'

class RetrieveNetworkJobTest < ActiveJob::TestCase
  test "something" do
    RetrieveNetworkJob.perform_now
  end
end
