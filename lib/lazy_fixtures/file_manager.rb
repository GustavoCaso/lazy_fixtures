module LazyFixtures
  class FileManager
    def initialize(name, options)
      @name = name
      @options = options
      @title = determine_name(@name)
      @file_path = File.join(LazyFixtures.configuration.factory_directory || 'spec/fixtures', @title)
    end

    def determine_name(name)
      raise 'Abstract Method for FileManager'
    end

    def create_file
      return unless @options[:create]
      if check_existence? && !@options[:overwrite]
        puts "There is a file already inside that folder with the same name #{@name}"
        puts "Would you like to overwrite that file? (yes/no)"
        answer = gets.chomp
        if answer ==  'yes'
          puts 'The generator is overwriting your file'
          File.new(@file_path, "w")
          true
        else
          puts 'Exiting the program'
          false
        end
      end
      puts "creating new file under #{@file_path}"
      File.new(@file_path, "w")
      true
    end

    def check_existence?
      File.file?(@file_path)
    end

    def write_file(text)
      raise 'Abstract method for FileManager'
    end
  end
end
