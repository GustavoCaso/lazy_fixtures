module LazyFixtures
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
      @class_name = @object.class.name
      @attributes = @object.attributes
      set_factory_body
    end

    def generate
      # In this first implementation of the gem it only allow to manipulate the
      # first object
      attribute_manager.manipulate_attributes
      add_associations if @options[:nested]
      @factory_body = attribute_manager.add_attributes
      text = generate_factory
      if create_file
        @file.write_file(text)
      end
      self
    end

    def generate_factory
      raise 'Abstract method for Generator'
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
          add_association_to_factory_body(association.columns_info[method], object_class, method)
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
      raise 'Abstract method for Generator'
    end

    def association
      raise 'Abstract method for Generator'
    end

    def attribute_manager
      raise 'Abstract method for Generator'
    end

    def add_association_to_factory_body(association_method_info, object_class, method)
      raise 'Abstract method for Generator'
    end

    def set_factory_body
      raise 'Abstract method for Generator'
    end
  end
end