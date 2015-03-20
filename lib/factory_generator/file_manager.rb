module FactoryGenerator
    class FileManager
      def initialize(name)
        @name = name
        @title = "#{@name}.rb"
        @file_path = File.join(FactoryGenerator.configuration.factory_directory, @title)
    end

    def create_file
      puts "creating file #{@title}"
      File.new(@file_path, "w")
    end

    def check_existence?
      File.file?(@file_path)
    end

    def write_file(text)
      puts "writing file #{@title}"
      File.open(@file_path, 'w') do |f|
        f.write text
      end
    end
  end
end
