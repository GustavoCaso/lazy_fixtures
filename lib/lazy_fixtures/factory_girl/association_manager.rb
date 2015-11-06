module LazyFixtures
  module FactoryGirl
    class AssociationManager
      include LazyFixtures::ObjectHelper

      attr_reader :object
      def initialize(object)
        @object = object
        @klass = @object.class.name.constantize
      end

      def get_associations
        columns_info.keys.map do |method|
          get_object(object.send(method))
        end
      end

      private

      def columns_info
        @klass.reflections.keys.map do |x|
          reflection = @klass.reflections[x]
          [
            x.to_s,
            {
              method: x.to_s,
              macro: reflection.macro,
              klass: reflection.class_name
            }
          ]
        end.to_h
      end

    end
  end
end
