class Vimnotes
  class Completion
    FILE_PATTERN = /(.+)-\d{4}-\d{2}-\d{2}[\d\-_\.]*\.txt/

    def self.complete(completion_line, argv=[])
      new(completion_line, Vimnotes::OptionParser.parse(argv)).complete
    end

    def initialize(completion_line, options)
      @completion_line, @options = completion_line, options
    end

    def complete
      return entries - arguments unless pattern
      entries.select do |entry|
        entry.start_with?(pattern) && !arguments.include?(entry)
      end
    end

    private

    def entries
      @options.directory.entries.sort.map do |entry|
        entry.to_s =~ FILE_PATTERN ? $1 : nil 
      end.compact.uniq
    end

    def pattern
      return if @completion_line[-1] =~ /\s/
      return if arguments.count < 2
      arguments.last
    end

    def arguments
      @completion_line.split(' ')
    end
  end
end
