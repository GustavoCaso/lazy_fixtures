module FactoryGenerator

    attr_accessor :path

    class FileManager
      def initialize(name, overwrite)
        @name = name
        @overwrite = overwrite
      end

    def create_file
      puts "creating file #{@path}"
      File.new(@path, "w")
    end

    def check_existence?
      File.file?(@path)
    end

    def write_file(text)
      puts "writing file #{@path}"
      File.open(@path, 'w') do |f|
        f.write text
      end
    end

    def check_and_create_file
      create_path
      if check_existence? && @overwrite
        create_file
      elsif check_existence? && !@overwrite
        create_path("#{@name}_2")
        create_file
      else
        create_file
      end
      self
    end

    def create_path(name = @name)
      @path = File.join(FactoryGenerator.configuration.factory_directory, "#{name}.rb")
    end
  end
end
