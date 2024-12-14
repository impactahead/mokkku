require 'yaml'
require_relative 'mocked_object'
require_relative 'uniq_utils'

module Mokkku
  module Utils
    def const_missing(const_name)
      if const_name.match?(/\:\:/)
        super(const_name)
      else
        mock_file_name = const_name.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
        mock_path = File.join(Mokkku.configuration.mocks_path, "#{mock_file_name}.yml")
        data = File.read(mock_path)
        parsed_data = YAML.safe_load(data, symbolize_names: true)
        mocked_object = Mokkku::MockedObject.new(const_name.to_s, parsed_data)
        unique_mocked_object = Mokkku::UniqueUtils.add_instance(mocked_object, 100)

        const_set const_name, unique_mocked_object

        unique_mocked_object
      end
    end
  end
end
