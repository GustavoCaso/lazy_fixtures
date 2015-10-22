require 'pry'
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
        run_associations if options[:nested]
      end

      private

      def generate_factory(text)
        factory_name = get_factory_name
        <<-EOF
FactoryGirl.define do
  factory :#{factory_name}, class: #{class_name.constantize} do
#{text.chomp}
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

      def run_associations
        get_associations.each do |association|
          unless options[:parent].include? association.class.name
            (options[:parent] << association.class.name).uniq!
            LazyFixtures::Generator.new(association, nested: true, parent: options[:parent]).
              generate('FactoryGirl')
          end
        end
      end

      def get_associations
        association.get_associations
      end

      def association
        AssociationManager.new(object)
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
