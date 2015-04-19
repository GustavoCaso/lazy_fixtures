module LazyFixtures
  class FixtureAssociation < LazyFixtures::AssociationManager

    def create_belongs_to_association(klass, class_name, method)
      {"#{method}" => class_name}
    end

    def create_has_many_associations(association_info)
      {"#{association_info[:method]}" => association_info[:klass].downcase}
    end
  end
end