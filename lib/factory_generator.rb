require "factory_generator/version"

module FactoryGenerator
  class FactoryGenerator
    def initialize(object)
      @object = object.respond_to?('first') ? object.first : object
      @attributes = @object.respond_to?('first') ? @object.first.attributes : @object.attributes
      return if File.file?("#{@object.class.name.downcase}.rb")
      create_file("#{@object.class.name.downcase}.rb")
      @key_columns = AssociationManager.new(@object).get_association_info
      @factory_body = ''
      write_associations
      write_attributes
      text = write_factory(@object, @factory_body)
      write_file(text, @object.class.name.downcase)
    end

    def write_factory(object, attributes)
      <<-EOF
FactoryGirl.define do
  factory :#{object.class.name.downcase} do
    #{attributes}
  end
end
      EOF
    end

    def write_associations
      @key_columns.keys.each do |method|
        begin
          puts "#{method}"
          object =  @object.send(method)
          next if object.nil? || (object.respond_to?('first') && object.empty?)
          self.class.new(object)
          binding.pry if AssociationManager.new(@object).determine_association(@key_columns[method]).nil?
          @factory_body += AssociationManager.new(@object).determine_association(@key_columns[method])
          @attributes.delete_if {|k,v| k =~ Regexp.new(method) && !v.nil?}
        rescue => e
          puts "There was an error creating the association #{e} => #{e.backtrace}"
          next
        end
      end
    end

    def write_attributes
      @attributes.each do |k,v|
        @factory_body += "#{k} #{map_values(v)}\n"
      end
    end

    def map_values(value)
      if value.class == String || value.class == ActiveSupport::TimeWithZone
        return_val = "\'#{value}\'"
      elsif value.nil?
        return_val = "nil"
      else
        return_val = value
      end
      return_val
    end

    def write_file(text, title)
      puts "writing file #{title}"
      File.open("#{title}.rb", 'w') do |f|
        f.write text
      end
    end

    def create_file(title)
      puts "creating file #{title}"
      File.new(title, "w")
    end
  end
end
