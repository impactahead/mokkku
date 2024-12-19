require 'set'

module Mokkku
  class UniqueUtils
    class << self
      def add_instance(generator, max_retries)
        instances[generator.mocked_class] ||= Mokkku::UniqueUtils.new(generator, max_retries)
      end

      def instances
        Thread.current[:mokkku_unique_utils] ||= {}
      end

      def clear
        instances.each_value(&:clear)
        instances.clear
      end
    end

    def initialize(generator, max_retries)
      @generator = generator
      @max_retries = max_retries
    end

    def clear
      previous_results.clear
    end

    private

    def method_missing(name, *args, **kwargs)
      if @generator.selected_object.nil? && @generator.send(:mocked_objects).first.to_h.keys.include?(name)
        @max_retries.times do
          next_object = @generator.send(:mocked_objects).sample(random: Mokkku::Random)
        
          next if previous_results.include?(next_object)

          previous_results << next_object
          @generator.instance_variable_set(:@selected_object, next_object)
          break
        end

        if @generator.selected_object.nil?
          previous_results.clear
          next_object = @generator.send(:mocked_objects).sample(random: Mokkku::Random)
          previous_results << next_object
          @generator.instance_variable_set(:@selected_object, next_object)
        end
      end

      @generator.public_send(name, *args, **kwargs)
    end

    def respond_to_missing?(name, *args)
      @generator.respond_to?(name, *args) || super
    end

    def previous_results
      @previous_results ||= Set.new
    end
  end
end
