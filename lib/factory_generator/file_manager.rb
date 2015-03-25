module FactoryGenerator
    class FileManager
      def initialize(name, options)
        @name = name
        @options = options
        @title = "#{@name}.rb"
        @file_path = File.join(FactoryGenerator.configuration.factory_directory, @title)
      end

    def create_file
      return unless @options[:create]
      puts "creating file #{@title}"
      File.new(@file_path, "w")
    end

    def check_existence?
      File.file?(@file_path)
    end

    def write_file(text)
      return unless @options[:create]
      puts "writing file #{@title}"
      File.open(@file_path, 'w') do |f|
        f.write text
      end
    end
  end
end
