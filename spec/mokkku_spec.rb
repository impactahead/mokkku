require 'spec_helper'

RSpec.describe Mokkku do
  before(:all) do
    Mokkku.configure do |config|
      config.mocks_path = './spec/mocks'
    end

    Mokkku::Random.seed = 1235
  end

  it 'returns data for existing mock' do
    expect(Mokkku::Company.name).to eq('Microsoft')
  end

  it 'locks the context' do
    expect(Mokkku::Company.website).to eq('https://microsoft.com')
  end

  it 'resets the context' do
    Mokkku::Company.reset_context!

    expect(Mokkku::Company.website).to eq('https://apple.com')
  end

  it 'raises error when attribute does not exist' do
    expect { Mokkku::Company.location }.to raise_error(NoMethodError)
  end

  it 'raises error when class does not exist' do
    expect { Mokkku::User.first_name }.to raise_error(Errno::ENOENT)
  end
end
