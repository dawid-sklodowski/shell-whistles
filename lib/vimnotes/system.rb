class Vimnotes
  module System
    extend self

    ROOT = Pathname.new(File.expand_path(__FILE__)) + '..' + '..' + '..'
    def execute(command, final = false)
      puts command
      if ENV['VIMNOTES_ENV'] == 'test'
        puts command
      else
        if final
          exec command
        else
          `#{command}`
        end
      end
    end

    def completion_path
      Vimnotes::System::ROOT + 'lib' + 'bin' + 'vimnotes_completion'
    end

    def vimnotes_path
      Vimnotes::System::ROOT + 'bin' + 'vimnotes'
    end
  end
end

