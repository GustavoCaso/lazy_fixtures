module LazyFixtures
  class FixtureGenerator < LazyFixtures::Generator
    def set_factory_body
      @factory_body = {}
    end

    def generate_factory
      @factory_body
    end

    def add_association_to_factory_body(association_method_info, object_class, method)
      @factory_body[@object.class.name.downcase].merge association.determine_association(association_method_info, object_class, method)
    end

    def create_file
      name = @object.class.name.underscore.pluralize
      @file ||= FixtureFile.new(name, @options)
      @file.create_file
    end

    def association
      FixtureAssociation.new(@object)
    end

    def attribute_manager
      @attribute_manager ||= FixtureAttributes.new(@object, @options)
    end
  end
end