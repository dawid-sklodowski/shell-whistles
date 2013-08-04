require 'fileutils'
ENV['VIMNOTES_ENV'] = 'test'
describe 'vimnotes' do
  ROOT = Pathname.new(File.expand_path(__FILE__)) + '..' + '..'
  TEST_DIR = ROOT + 'test_tmp'

  def run(command)
    `#{ROOT + 'bin' + 'vimnotes'} -d #{TEST_DIR} #{command}`
  end

  after(:each) do
    FileUtils.rm_rf TEST_DIR
  end

  it 'creates directory if needed' do
    TEST_DIR.should_not be_exist
    run('test')
    TEST_DIR.should be_exist
  end

  it 'creates new file with today date if no exists' do

  end

  it 'opens existing file if it exists' do

  end

  describe '-n option' do
    it 'creates new file if none exist' do

    end

    it 'it creates new file with today date if file exists with previous date' do

    end

    it 'creates new file with today timestamp if file exists with today date' do

    end
  end
end