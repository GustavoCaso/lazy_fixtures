module LazyFixtures
  class FixtureAttributes < LazyFixtures::AttributesManager
    def add_attributes
      @attributes.delete('id')
      @factory_body[@object.class.name.underscore] = @attributes
      @factory_body
    end
  end
end