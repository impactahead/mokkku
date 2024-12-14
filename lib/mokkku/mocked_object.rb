module Mokkku
  class MockedObject
    attr_reader :mocked_class
    attr_accessor :selected_object

    def initialize(mocked_class, mocks)
      @mocked_class = mocked_class
      @mocks = mocks
      @selected_object = nil
    end

    def reset_context!
      @selected_object = nil
    end

    private

    def mocked_objects
      @mocked_objects ||= @mocks.map do |mock_attrs|
        Data.define(*mock_attrs.keys.map(&:to_sym)).new(**mock_attrs)
      end
    end

    def method_missing(method_name, *args, &block)
      @selected_object.public_send(method_name)
    end
  end
end
