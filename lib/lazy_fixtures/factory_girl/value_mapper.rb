module LazyFixtures
  module FactoryGirl
    class ValueMapper
      attr_reader :object, :key, :object_class

      def initialize(object, key, value)
        @object = object
        @object_class = @object.class.name.constantize
        @key = key
        @value = value
        remove_encrypted_attributes
      end

      def remove_encrypted_attributes
        if key =~ /(encrypted_)/
          new_key = key.dup
          new_key.slice!($1)
          @value = object.send(new_key)
        end
      end

      def get_value
        type = object_class.columns_hash[key].type
        if @value.nil?
           "nil"
         elsif type == :integer || type == :float
           @value
         else
           "\'#{@value}\'"
         end
      end

      def self.remove_encrypted(key)
        return_key = key
        if key =~ /(encrypted_)/
          return_key.slice!($1)
        end
        return_key
      end
    end
  end
end
