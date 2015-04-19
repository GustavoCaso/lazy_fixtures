module LazyFixtures
  class FixtureAttributes < LazyFixtures::AttributesManager
    def add_attributes
      @attributes.delete('id')
      @factory_body[@object.class.name.downcase] = @attributes
      @factory_body
    end

    def delete_association_attributes(method)
      @factory_body[@object.class.name.downcase].delete_if do |k,v|
        k =~ Regexp.new(method) && !v.nil? && (v.to_s != k.to_s)
      end
      @factory_body
    end
  end
end