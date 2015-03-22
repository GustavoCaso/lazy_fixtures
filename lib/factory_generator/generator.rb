module FactoryGenerator
  class Generator

    DEFAULT_OPTIONS = {
        nested: false,
        overwrite: false,
        parent: [],
        skip_params: [],
        params: {}
    }

    def initialize(object, options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      object = get_object(object)
      @existing_factories = FactoryGenerator.configuration.factory_names
      generate(object)
    end

    def generate(object)
      attributes =  manipulate_attributes(object.attributes)
      association_body = ''
      association_body, attributes = write_associations(object, attributes, association_body) if @options[:nested]
      klass = object.class.name.downcase
      association_body = write_attributes(object, attributes ,association_body)
      file_manager =  generate_file(klass)
      text = write_factory(klass, association_body)
      file_manager.write_file(text)
    end

    def manipulate_attributes(attributes)
      attr = attributes
      @options[:skip_params].each { |x|  attr.delete(x)} unless @options[:skip_params].empty?
      attr.merge!(@options[:params]) unless @options[:params].empty?
      attr
    end


    def write_factory(class_name, attributes)
      name = @existing_factories.include?(class_name) ? "#{class_name}_2" : class_name
      <<-EOF
FactoryGirl.define do
  factory :#{name}, class: #{class_name.capitalize.constantize} do
#{attributes}
  end
end
      EOF
    end

    def write_associations(object, attributes, association_body)
      association = AssociationManager.new(object)
      columns_assosiation_hash = association.get_association_info
      columns_assosiation_hash.keys.each do |method|
        begin
          object = get_object(object.send(method))
          object_class = object.class.name
          next if object.nil? || (object.respond_to?('first') && object.empty?)
          parent_included = @options[:parent].include? object_class
          (@options[:parent] << object_class).uniq!
          generate(object) unless parent_included
          association_body += association.determine_association(columns_assosiation_hash[method], object_class, method)
          attributes.delete_if {|k,v| k =~ Regexp.new(method) && !v.nil?}
          [association_body, attributes]
        rescue => e
          puts "There was an error creating the association #{e} => #{e.backtrace}"
          next
        end
      end
    end

    def write_attributes(object, attributes, association_body)
      body = association_body
      attributes.each do |k,v|
        value =  ValueMapper.new(object, k.dup, v).map_values
        key = ValueMapper.remove_encrypted(k.dup)
        body += "    #{key} #{value}\n"
      end
      body
    end

    def generate_file(klass)
      FileManager.new(klass, @options[:overwrite]).check_and_create_file
    end

    def get_object(object)
      object.respond_to?('first') ? object.first : object
    end
  end
end
