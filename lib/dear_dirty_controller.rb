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
        body serialize(execute)
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

  class A
    include DearDirtyController::Mixin

    headers "SOME-KEY" => "SOME-VALUE"
    content_type "application/json"

    rescue_from StandardError do |error|
      status 500
      body "something went wrong"
    end

    rescue_all do |error|
      status 501
      body "something went wrong 2"
    end

    before do
      @context.messages = ["before"]
      puts "before"
    end

    def execute
      @context.messages << "call"
      puts "execute"
      status 201
      { a: 1 }
    end

    after do
      @context.messages << "after"
      puts "after"
      puts @context.messages.to_s
    end

    serialize do |response|
      array = []
      response.keys.each do |key|
        array << "'#{key}': '#{response[key]}'"
      end
      "{#{array.join(", ")}}"
    end
  end

  # config/routes.rbには以下のように記述する
  # get "/a", to: DearDirtyController::A
end
