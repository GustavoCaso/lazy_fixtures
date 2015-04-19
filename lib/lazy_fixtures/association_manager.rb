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
      result = if relation == :belongs_to
               create_belongs_to_association(association_info[:klass], class_name, method)
             elsif relation == :has_many || relation == :has_and_belongs_to_many
               create_has_many_associations(association_info)
             end
      return_value(result)
    end

    def create_belongs_to_association(klass, class_name, method)
     raise 'Abstract method for AssociationManager'
    end

    def create_has_many_associations(associaton_info)
      raise 'Abstract method for AssociationManager'
    end

    def return_value(result)
      raise 'Abstract method for AssociationManager'
    end
  end
end
