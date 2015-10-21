module LazyFixtures
  module FactoryGirl
    class FileManager
      attr_reader :name, :file_path
      def initialize(name, options)
        @name = name
        @options = options
        @file_path = File.join(global_factory_directory, get_file_name)
      end

      def create_file
        return unless @options[:create]
        if check_existence? && !@options[:overwrite]
          puts "There is a file already inside that folder with the same name #{get_file_name}"
          puts "Would you like to overwrite that file? (yes/no)"
          answer = gets.chomp
          if answer ==  'yes'
            puts 'The generator is overwriting your file'
            File.new(file_path, "w")
            true
          else
            puts 'Exiting the program'
            false
          end
        end
        puts "creating new file under #{global_factory_directory}/#{get_file_name}"
        File.new(file_path, "w")
        true
      end

      def check_existence?
        File.file?(file_path)
      end

      def write_file(text)
        File.open(file_path, 'w') do |f|
          f.write text
        end
      end

      def global_factory_directory
        LazyFixtures.configuration.factory_directory
      end

      def get_file_name
        "#{name}.rb"
      end
    end
  end
end


