class FileManager
  def initialize(name)
    @name = name
    @title = "#{@name}.rb"
  end

  def create_file
    puts "creating file #{@title}"
    File.new(@title, "w")
  end

  def check_existence?
    File.file?("spec/factories/#{@title}")
  end

  def write_file(text)
    puts "writing file #{@title}"
    File.open("#{@title}", 'w') do |f|
      f.write text
    end
  end
end
