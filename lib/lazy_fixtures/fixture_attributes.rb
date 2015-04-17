module LazyFixtures
  class FixtureAttributes < LazyFixtures::AttributesManager
    def add_attributes
      return_value = {}
      @attributes.delete('id')
      return_value[@object.class.name.downcase] = @attributes
      return_value
    end

    def delete_association_attributes(method)
      @attributes[@object.class.name.downcase].delete_if do |k,v|
        k =~ Regexp.new(method) && !v.nil?
      end
    end
  end
end