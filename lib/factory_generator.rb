require "factory_generator/version"

module FactoryGenerator
  class FactoryGenerator
  def initialize(object)
    @object = object
    @key_columns = AssociationManager.new(@object).get_association_info
    attributes =  write_attributes(@object)
    text = write_factory(@object, attributes)
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

  def write_attributes(object)
    result = ''
    object.attributes.each do |k,v|
      if @key_columns.keys.map{|x| "#{x}_id"}.include?(k)
        result += create_association(@key_columns[k.gsub('_id', '')], v) || "#{k} #{map_values(v)}\n"
      else
        result += "#{k} #{map_values(v)}\n"
      end
    end
    result
  end

  def remove_attributes_if_association_present
    @object.attributes.delete_if do |key, value|

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
    puts "creating file #{title}"
    File.open("#{title}.rb", 'w') do |f|
      f.write text
    end
  end

  def create_association(table_info, id)
    begin
      object = get_object(table_info[:klass], id)
      self.class.new(object)
      AssociationManager.determine_association(table_info)
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
