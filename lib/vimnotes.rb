require 'vimnotes/option_parser'
require 'vimnotes/system'
require 'vimnotes/init'
require 'date'

class Vimnotes
  Error = Class.new(StandardError)

  def self.run(argv)
    new(Vimnotes::OptionParser.parse(argv)).execute
  rescue Vimnotes::Error => e
    puts "Error: #{e.message}"
    exit(1)
  end

  def initialize(options)
    @options = options
    prepare
  end

  def execute
    send(@options.command)
  end

  private

  def prepare
    @options.directory.mkpath unless @options.directory.exist?
  end

  def init
    Vimnotes::Init.new(@options).init
  end

  def open
    mandatory_filename
    command = "vim -c ':lcd #{@options.directory}' #{file_to_edit}"
    Vimnotes::System.execute(command, true)
  end

  def delete
    mandatory_filename
    command = "rm #{@options.directory + file_to_edit}" 
    Vimnotes::System.execute(command, true)
  end

  def cat
    mandatory_filename
    command = "cat #{@options.directory + file_to_edit}" 
    Vimnotes::System.execute(command, true)
  end

  def mandatory_filename
    raise Vimnotes::Error, "Filename is mandatory.\n Use -h for help" unless @options.argument
  end


  def file_regexp
    /^#{@options.argument}-([\d\-_\.]+)\.txt$/
  end

  def latest_file
    @options.directory.entries.select{ |entry| entry.to_s =~ file_regexp }.sort.last
  end

  def latest_file_today?
    return unless latest_file
    if latest_file.to_s =~ file_regexp
      Date.parse($1) == Date.today
    end
  end

  def file_to_edit
    @options.directory + (
    if @options.new
      if latest_file_today?
        "#{@options.argument}-#{Time.now.strftime('%Y-%m-%d_%H.%M.%S')}.txt"
      else
        "#{@options.argument}-#{Date.today}.txt"
      end
    else
      if latest_file
        latest_file
      else
        "#{@options.argument}-#{Date.today}.txt"
      end
    end
    )
  end
end
