module LazyFixtures
  class FactoryGirlFile < LazyFixtures::FileManager
    def determine_name(name)
      "#{name}.rb"
    end

    def write_file(text)
      File.open(@file_path, 'w') do |f|
        f.write text
      end
    end
  end
end