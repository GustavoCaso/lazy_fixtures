module LazyFixtures
  class FixtureAssociation < LazyFixtures::AssociationManager

    def create_belongs_to_association(association_info, class_name, method)
      if association_info[:polymorphic]
        {"#{method}" => "#{class_name.underscore} (#{class_name.constantize})"}
      else
        {"#{method}" => class_name.underscore}
      end
    end

    def create_has_many_associations(association_info)
      {"#{association_info[:method]}" => association_info[:klass].underscore}
    end

    def return_value(value)
      value
    end
  end
end