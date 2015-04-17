module LazyFixtures
  class FactoryGirlGenerator < LazyFixtures::Generator
    def set_factory_body
      @factory_body = ''
    end

    def generate_factory
      factory_name = get_factory_name
      <<-EOF
FactoryGirl.define do
  factory :#{factory_name}, class: #{@class_name.constantize} do
#{@factory_body}
  end
end
      EOF
    end

    def add_association_to_factory_body(association_method_info, object_class, method)
      @factory_body += association.determine_association(association_method_info, object_class, method)
    end

    def create_file
      name = @object.class.name.underscore.pluralize
      @file ||= FactoryGirlFile.new(name, @options)
      @file.create_file
    end

    def association
      FactoryGirlAssociation.new(@object)
    end

    def attribute_manager
      @attribute_manager ||= FactoryGirlAttributes.new(@object, @options)
    end

    def get_factory_name
      if LazyFixtures.configuration.factory_names.include?(@class_name.downcase)
        "#{@class_name.downcase}_new"
      else
        @class_name.downcase
      end
    end
  end
end