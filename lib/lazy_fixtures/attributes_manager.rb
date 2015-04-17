module LazyFixtures
  class AttributesManager

    attr_accessor :attributes

    def initialize(object, options={})
      @object = object
      @attributes = @object.attributes
      @options    = options
    end

    def add_attributes
      return_value = ''
      attributes.each do |k,v|
        value =  ValueMapper.new(@object, k.to_s.dup, v).map_values
        key = ValueMapper.remove_encrypted(k.to_s.dup)
        return_value += "    #{key} #{value}\n"
      end
      return_value
    end

    def manipulate_attributes
      @options[:skip_attr].each { |x|  attributes.delete(x)} unless @options[:skip_attr].empty?
      attributes.merge!(@options[:change_attr]) unless @options[:change_attr].empty?
      attributes
    end

    def delete_association_attributes(method)
      raise 'Abstract method for Attributes manager'
    end

    def each
      attributes
    end
  end
end
