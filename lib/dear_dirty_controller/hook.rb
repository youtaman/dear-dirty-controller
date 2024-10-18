# frozen_string_literal: true

module DearDirtyController
  module Hook
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module InstanceMethods
      private

      def run_before_callbacks
        self.class._before_callbacks&.each { instance_exec(&_1) }
      end

      def run_after_callbacks
        self.class._after_callbacks&.each { instance_exec(&_1) }
      end
    end

    module ClassMethods
      attr_reader :_before_callbacks, :_after_callbacks

      private

      def before(&block)
        return unless block_given?

        @_before_callbacks ||= []
        @_before_callbacks << block
      end

      def after(&block)
        return unless block_given?

        @_after_callbacks ||= []
        @_after_callbacks << block
      end
    end
  end
end
