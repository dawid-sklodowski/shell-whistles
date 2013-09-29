require 'spec_helper'

describe Vimnotes::Completion do
  before :each do
    TEST_DIR.mkdir
  end

  let(:argv) { ['name', '-d', TEST_DIR.to_s] }

  it 'returns all files when no letter yet' do
    (TEST_DIR + "one-#{Date.today}.txt").open('w'){}
    (TEST_DIR + "two-#{Date.today}.txt").open('w'){}
    described_class.complete('v', argv).should == ['one', 'two']
  end

  it 'returns all files when no letter yet #2' do
    (TEST_DIR + "one-#{Date.today}.txt").open('w'){}
    (TEST_DIR + "two-#{Date.today}_23.03.12.txt").open('w'){}
    described_class.complete('v ', argv).should == ['one', 'two'] 
  end

  it 'returns only newest file if there are two same files (with different dates)' do
    (TEST_DIR + "one-#{Date.today}.txt").open('w'){}
    (TEST_DIR + "one-#{Date.today - 10}.txt").open('w'){}
    described_class.complete('v', argv).should == ['one']
  end

  it 'returns only matching files when there are letters' do
    (TEST_DIR + "one-#{Date.today}.txt").open('w'){}
    (TEST_DIR + "two-#{Date.today}.txt").open('w'){}
    described_class.complete('v on', argv).should == ['one']
  end
end

