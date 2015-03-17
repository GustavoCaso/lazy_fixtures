require "factory_generator/version"

module FactoryGenerator
  class FactoryGenerator
    def initialize(object)
      @object = object
      @klass = object.class.name.constantize
      @key_columns = {}
      save_associations
      attributes =  write_attributes(@object)
      text = write_factory(@object, attributes)
      write_file(text, @object.class.name.downcase)
    end

    def save_associations
      @klass.reflections.keys.map do |x|
        reflection = @klass.reflections[x]
        @key_columns[x.to_s]= {
            klass: reflection.class_name,
            foreign_key: reflection.foreign_key,
            foreign_type: reflection.foreign_type,
            polymorphic: reflection.polymorphic?,
        }
      end
    end

    def write_factory(object, attributes)
      <<-EOF
FactoryGirl.define do
  factory :#{object.class.name.downcase.to_sym} do
    #{attributes}
  end
end
      EOF
    end

    def write_attributes(object)
      result = ''
      object.attributes.each do |k,v|
        if @key_columns.keys.map{|x| "#{x}_id"}.include?(k)
          create_association(@key_columns[k.gsub('_id', '')], v)
          result += "#{k} #{map_values(v)}\n"
        else
          result += "#{k} #{map_values(v)}\n"
        end
      end
      result
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
      puts "creating file #{title}"
      File.open("#{title}.rb", 'w') do |f|
        f.write text
      end
    end

    def create_association(table_info, id)
      begin
        object = get_object(table_info[:klass], id)
        attributes =  write_attributes(object)
        text = write_factory(object, attributes)
        write_file(text, object.class.name.downcase)
      rescue => e
        puts "There was an error creating the association #{e}"
        return
      end
    end

    def get_object(klass, id)
      klass.constantize.find(id)
    end
  end
end
