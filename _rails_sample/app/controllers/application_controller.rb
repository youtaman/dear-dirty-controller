class ApplicationController
  include DearDirtyController::Mixin

  attr_reader :request

  content_type "application/json"

  rescue_from StandardError do |error|
    status 500
    body "something went wrong"
  end

  rescue_from ActiveRecord::RecordNotFound do |error|
    status 404
    body "record not found"
  end

  rescue_all do |error|
    status 501
    body "something went wrong"
  end

  def initialize(args)
    super(args)
    @request = ActionDispatch::Request.new(args)
  end

  def params
    ActionController::Parameters.new(
      request.params
    )
  end
end
