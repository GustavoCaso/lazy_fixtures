module LazyFixtures
  class AssociationManager
    def initialize(item)
      @item = item
      @klass = @item.class.name.constantize
    end

    def columns_info
      return_hash = {}
      @klass.reflections.keys.map do |x|
        reflection = @klass.reflections[x]
        return_hash[x.to_s]= {
            method: x.to_s,
            macro: reflection.macro,
            klass: reflection.class_name
        }
      end
      return_hash
    end

    def determine_association(association_info, class_name, method)
      relation = association_info[:macro]
      text = if relation == :belongs_to
               create_belongs_to_association(association_info[:klass], class_name, method)
             elsif relation == :has_many || relation == :has_and_belongs_to_many
               create_has_many_associations(association_info[:klass])
             end
      <<-EOF
    #{text}
      EOF
    end

    def create_belongs_to_association(klass, class_name, method)
      method = method == klass.downcase ? klass.downcase : method
      class_name = klass == class_name ? klass : class_name
      "association :#{method}, factory: :#{class_name.downcase}"
    end

    def create_has_many_associations(klass)
      %Q(after(:create) do |x|
      create_list(:#{klass.downcase}, 1, #{@item.class.name.downcase}: x)
    end)
    end
  end
end
