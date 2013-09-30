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
          "-D",
          "--directory <DIRECTORY>",
          "Store notes in directory, defaults to #{@options.directory}"
        ) do |directory|
          @options.directory = Pathname.new(directory)
        end

        opts.on('-d', '--delete', 'Deletes notes file') do
          @options.command = 'delete'
        end


        opts.on('--no-v', 'Init without v command') do
          @options.no_v = true
        end

        opts.on('--init', 'Links stuff') do |silent|
          @options.command = 'init'
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end.parse!(argv)

      @options.argument = argv.first
    end
  end
end
