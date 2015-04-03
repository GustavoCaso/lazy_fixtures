module FactoryGenerator
  class Generator

    attr_reader :factory_body, :attributes, :options

    DEFAULT_OPTIONS = {
        nested:      false,
        overwrite:   false,
        create:      true,
        parent:      [],
        skip_attr:   [],
        change_attr: {}
    }

    def initialize(object, options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @object = get_object(object)
      @attributes = @object.attributes
      @factory_body = ''
    end

    def generate
      # In this first implementation of the gem it only allow to manipulate the
      # first object
      attribute_manager.manipulate_attributes
      add_associations if @options[:nested]
      @factory_body += attribute_manager.add_attributes
      text = generate_factory(@object.class.name.downcase, @factory_body)
      if create_file
        @file.write_file(text)
      end
      self
    end

    def generate_factory(class_name, attributes)
      <<-EOF
FactoryGirl.define do
  factory :#{class_name} do
#{attributes}
  end
end
      EOF
    end

    def add_associations
      association.columns_info.keys.each do |method|
        begin
          object =  @object.send(method)
          object = get_object(object)
          object_class = object.class.name
          next if invalid_object?(object)
          parent_included = @options[:parent].include? object_class
          (@options[:parent] << object_class).uniq!
          self.class.new(object, nested: true, parent: @options[:parent]).generate unless parent_included
          @factory_body += association.determine_association(association.columns_info[method], object_class, method)
          attribute_manager.delete_association_attributes(method)
        rescue => e
          puts "There was an error creating the association #{e} => #{e.backtrace}"
          next
        end
      end
    end

    def get_object(object)
      object.respond_to?('first') ? object.first : object
    end

    def invalid_object?(object)
      object.nil? || (object.respond_to?('first') && object.empty?)
    end

    def create_file
      @file ||= FileManager.new(@object.class.name.downcase, @options)
      @file.create_file
    end

    def association
      AssociationManager.new(@object)
    end

    def attribute_manager
      @attribute_manager ||= AttributesManager.new(@object, @options)
    end
  end
end
