# frozen_string_literal: true
require "json"

module DearDirtyController
  module Serializable
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module InstanceMethods
      private

      def serialize(execute_result)
        if self.class._serialize_block
          self.class._serialize_block.call(execute_result)
        elsif self.class._serializer_class
          self.class._serializer_class.send(self.class._serialize_method, execute_result)
        else
          execute_result.to_json
        end
      end
    end

    module ClassMethods
      attr_reader :_serializer_class, :_serialize_method
      attr_reader :_serialize_block

      private

      def serializer(klass, **params)
        return if klass.nil?

        @_serializer_class = klass
        @_serialize_method = params[:method] || :serialize
      end

      def serialize(&block)
        return unless block_given?

        @_serialize_block = block
      end
    end
  end
end
