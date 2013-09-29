$:.unshift File.expand_path('../../lib', __FILE__)
require 'vimnotes'
require 'pry'
require 'fileutils'
require 'date'

ENV['VIMNOTES_ENV'] = 'test'
TEST_DIR = Vimnotes::System::ROOT + 'test_tmp'

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    FileUtils.rm_rf TEST_DIR
  end

  config.after(:all) do
    FileUtils.rm_rf TEST_DIR
  end
end

