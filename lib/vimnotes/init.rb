class Vimnotes
  class Init
    def initialize(options)
      @options = options
    end

    def init
      if @options.argument
        set_completion
        set_system_path if path_change_required?
      else
        message
      end
    end

    private

    def set_completion
      puts("complete -C #{Vimnotes::System.completion_path} vimnotes;")
      puts("complete -C #{Vimnotes::System.completion_path} v;") unless @options.no_v
    end

    def set_system_path
      puts("export PATH=$PATH:#{Vimnotes::System::ROOT + 'bin'};")
    end

    def path_change_required?
      `which vimnotes`
      !$?.success?
    end

    def message
      puts <<-EOS
  Copy paste folowing line to your .bashrc
  eval $(#{Vimnotes::System.vimnotes_path} --init -)
EOS
    end
    
  end
end
