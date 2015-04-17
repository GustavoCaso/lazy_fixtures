module LazyFixtures
  class FactoryGirlAssociation < LazyFixtures::AssociationManager

    def create_belongs_to_association(klass, class_name, method)
      method = method == klass.downcase ? klass.downcase : method
      class_name = klass == class_name ? klass : class_name
      "association :#{method}, factory: :#{class_name.downcase}"
    end

    def create_has_many_associations(association_info)
      %Q(after(:create) do |x|
      create_list(:#{association_info[:klass].downcase}, 1, #{@item.class.name.downcase}: x)
    end)
    end

  end
end