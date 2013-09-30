require 'spec_helper'
describe 'vimnotes' do

  def run(options)
    `#{Vimnotes::System::ROOT + 'bin' + 'vimnotes'} -D #{TEST_DIR} #{options}`
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

  it 'does not open files having part of name' do
    TEST_DIR.mkpath
    (TEST_DIR + 'atest_file-2010-04-27.txt').open('w') { |file| file << 'test' }
    run('test_file').should =~ /test_file-#{Time.now.strftime('%Y-%m-%d')}.txt$/
  end

  it 'sets vim current dir to Vimnotes dir' do
    run('test_file').should =~ /-c ':lcd #{TEST_DIR}'/
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

  describe 'deleting files' do
    it('deletes given file') do
      TEST_DIR.mkpath
      (TEST_DIR + 'test_file-2010-04-27.txt').open('w') { |file| file << 'test' }
      run('-d test_file').should =~ /^rm .+test_file-2010-04-27\.txt/
    end
  end
end
