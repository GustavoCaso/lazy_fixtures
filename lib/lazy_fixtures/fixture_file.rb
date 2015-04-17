module LazyFixtures
  class FixtureFile < LazyFixtures::FileManager
    def determine_name(name)
      "#{name}.yml"
    end

    def write_file(text)
      File.open(@file_path, 'w') do |f|
        f.write text.to_yaml
      end
    end
  end
end