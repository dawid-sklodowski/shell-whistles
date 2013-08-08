require 'fileutils'
ENV['VIMNOTES_ENV'] = 'test'
describe 'vimnotes' do
  ROOT = Pathname.new(File.expand_path(__FILE__)) + '..' + '..' + '..'
  TEST_DIR = ROOT + 'test_tmp'

  def run(options)
    `#{ROOT + 'bin' + 'vimnotes'} -d #{TEST_DIR} #{options}`
  end

  before(:each) do
    FileUtils.rm_rf TEST_DIR
  end

  it 'creates directory if needed' do
    TEST_DIR.should_not be_exist
    run('test')
    TEST_DIR.should be_exist
  end

  it 'creates new file with today date if no exists' do
    run('test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}/
  end

  it 'opens existing file if it exists' do
    TEST_DIR.mkpath
    (TEST_DIR + 'test_file-2010-04-27.txt').open('w') { |file| file << 'test' }
    run('test_file').should =~ /test_file-2010-04-27\.txt/
  end

  it 'does not open files ending with ~' do
    TEST_DIR.mkpath
    (TEST_DIR + 'test_file-2010-04-27.txt~').open('w') { |file| file << 'test' }
    run('test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}.txt$/
  end

  describe '-n option' do
    it 'creates new file if none exist' do
      run('-n test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}/
    end

    it 'it creates new file with today date if file exists with previous date' do
      TEST_DIR.mkpath
      (TEST_DIR + 'test_file-2010-04-27.txt').open('w') { |file| file << 'test' }
      run('-n test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}.txt/
    end

    it 'creates new file with today timestamp if file exists with today date' do
      TEST_DIR.mkpath
      (TEST_DIR + "test_file-#{Time.now.strftime('%Y-%m-%d')}.txt").open('w') { |file| file << 'test' }
      run('-n test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}_\d{2}\.\d{2}\.\d{2}\.txt/
    end
  end
end
