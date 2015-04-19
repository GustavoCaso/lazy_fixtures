module LazyFixtures
  class AttributesManager

    attr_accessor :attributes

    def initialize(object, factory_body= nil, options={})
      @object = object
      @attributes = @object.attributes
      @factory_body = factory_body
      @options    = options
    end

    def manipulate_attributes
      @options[:skip_attr].each { |x|  attributes.delete(x)} unless @options[:skip_attr].empty?
      attributes.merge!(@options[:change_attr]) unless @options[:change_attr].empty?
      attributes
    end

    def add_attributes
      raise 'Abstract method for Attributes manager'
    end

    def delete_association_attributes(method)
      raise 'Abstract method for Attributes manager'
    end

    def each
      attributes
    end
  end
end
