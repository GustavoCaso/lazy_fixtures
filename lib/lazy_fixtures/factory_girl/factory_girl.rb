module LazyFixtures
  module FactoryGirl
    class FactoryGirl
      attr_reader :object, :options

      def initialize(obejct, options)
        @object = obejct
        @options = options
      end

      def generate
        if create_file
          @file.write_file(generate_factory(
            AttributesManager.new(object, options).
            stringify_attributes)
          )
        end
        self
      end

      private

      def generate_factory(text)
        factory_name = get_factory_name
        <<-EOF
  FactoryGirl.define do
    factory :#{factory_name}, class: #{class_name.constantize} do
  #{text}
    end
  end
        EOF
      end

      def create_file
        @file ||= FileManager.new(class_name_underscore, options)
        @file.create_file
      end

      def get_factory_name
        if global_factory_names.include?(class_name_underscore)
          "#{class_name_underscore}_new"
        else
          class_name_underscore
        end
      end

      def global_factory_names
        LazyFixtures.configuration.factory_names
      end

      def class_name
        object.class.name
      end

      def class_name_underscore
        class_name.underscore
      end
    end
  end
end

# def add_associations
    #   association.columns_info.keys.each do |method|
    #     begin
    #       object = get_object(@object.send(method))
    #       object_class = object.class.name
    #       next if invalid_object?(object)
    #       (@options[:parent] << object_class).uniq!
    #       self.class.new(object, nested: true, parent: @options[:parent]).generate unless @options[:parent].include?(object_class)
    #       @result_body += association.determine_association(association.columns_info[method], object_class, method)
    #       attribute_manager.delete_association_attributes(method)
    #     rescue => e
    #       puts "There was an error creating the association #{e} => #{e.backtrace}"
    #       next
    #     end
    #   end
    # end



    # def association
    #   AssociationManager.new(@object)
    # end
