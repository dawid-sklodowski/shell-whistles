require 'optparse'
require 'ostruct'
require 'pathname'

class Vimnotes
  module OptionParser
    extend self

    def parse(argv)
      @options = OpenStruct.new
      @options.new = false
      @options.directory = Pathname.new(ENV['HOME']) + 'Documents/Vimnotes'
      @options.command = 'open'
      process_argv(argv)
      @options
    end

    private

    def process_argv(argv)
      ::OptionParser.new do |opts|
        opts.banner = "Usage: vimnotes [options] filename"

        opts.on("-n", "--new", "Create new file") do
          @options.new = true
        end

        opts.on(
          "-d",
          "--directory <DIRECTORY>",
          "Store notes in directory, defaults to #{@options.directory}"
        ) do |directory|
          @options.directory = Pathname.new(directory)
        end

        opts.on('--init', 'Links stuff') do
          @options.command = 'init'
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end.parse!(argv)

      if argv.empty? || argv.first.empty?
        raise Vimnotes::Error, "Filename is mandatory.\n Use -h option for help"
      end
      @options.name = argv.first
    end
  end
end
