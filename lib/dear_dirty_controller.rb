# frozen_string_literal: true

require_relative "dear_dirty_controller/context"
require_relative "dear_dirty_controller/error_handler"
require_relative "dear_dirty_controller/hook"
require_relative "dear_dirty_controller/rack_response"
require_relative "dear_dirty_controller/serializable"
require_relative "dear_dirty_controller/version"

module DearDirtyController
  module Mixin
    attr_reader :context, :args

    def self.included(base)
      base.extend ClassMethods
      base.include DearDirtyController::ErrorHandler
      base.include DearDirtyController::Hook
      base.include DearDirtyController::RackResponse
      base.include DearDirtyController::Serializable
    end

    def initialize(*args)
      @args = args
    end

    def call
      @context = Context.new
      begin
        run_before_callbacks
        body serialize(execute) unless skip_execution?
        run_after_callbacks
      rescue => e
        try_rescue e
      end
      build_rack_response
    end

    def execute
      raise NotImplementedError
    end

    module ClassMethods
      def call(...)
        new(...).call
      end
    end
  end
end
