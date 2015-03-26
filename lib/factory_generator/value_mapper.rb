module FactoryGenerator
  class ValueMapper
    def initialize(object, key, value)
      @object = object
      @object_class = @object.class.name.constantize
      @key = key
      @value = value
      remove_encrypted_attributes
    end

    def remove_encrypted_attributes
       if @key =~ /(encrypted_)/
         key = @key.dup
         key.slice!($1)
         @value = @object.send(key)
       end
    end

    def map_values
      type = @object_class.columns_hash[@key].type
      value =  if @value.nil?
                 "nil"
               elsif type == :string || type == :datetime || type == :text || type == :date
                 "\'#{@value}\'"
               else
                 @value
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
