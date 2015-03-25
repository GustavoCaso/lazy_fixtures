module FactoryGenerator
  class Generator

    attr_reader :factory_body

    DEFAULT_OPTIONS = {
        nested: false,
        overwrite: false,
        create: true,
        parent: [],
        skip_params: [],
        params: {}
    }

    def initialize(object, options = {})
      options = DEFAULT_OPTIONS.merge(options)

      @object = get_object(object)
      @parent = options[:parent]
      klass = @object.class.name.downcase
      @attributes = @object.attributes
      options[:skip_params].each { |x|  @attributes.delete(x)} unless options[:skip_params].empty?
      @attributes.merge!(options[:params]) unless options[:params].empty?
      @association = AssociationManager.new(@object)
      @file = FileManager.new(klass, options)
      @file.create_file
      @key_columns = @association.get_association_info
      @factory_body = ''
      write_associations if options[:nested]
      write_attributes
      text = write_factory(klass, @factory_body)
      @file.write_file(text)
    end

    def write_factory(class_name, attributes)
      <<-EOF
FactoryGirl.define do
  factory :#{class_name.downcase} do
#{attributes}
  end
end
      EOF
    end

    def write_associations
      @key_columns.keys.each do |method|
        begin
          object =  @object.send(method)
          object = get_object(object)
          object_class = object.class.name
          next if object.nil? || (object.respond_to?('first') && object.empty?)
          parent_included = @parent.include? object_class
          (@parent << object_class).uniq!
          self.class.new(object, nested: true, parent: @parent) unless parent_included
          @factory_body += @association.determine_association(@key_columns[method], object_class, method)
          @attributes.delete_if {|k,v| k =~ Regexp.new(method) && !v.nil?}
        rescue => e
          puts "There was an error creating the association #{e} => #{e.backtrace}"
          next
        end
      end
    end

    def write_attributes
      @attributes.each do |k,v|
        value =  ValueMapper.new(@object, k.dup, v).map_values
        key = ValueMapper.remove_encrypted(k.dup)
        @factory_body += "    #{key} #{value}\n"
      end
    end

    def get_object(object)
      object.respond_to?('first') ? object.first : object
    end
  end
end
