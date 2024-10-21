class GetCurrentTimeController < ApplicationController
  def execute
    { current_time: Time.now.iso8601 }
  end
end
