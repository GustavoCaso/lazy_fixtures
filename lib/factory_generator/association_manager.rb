class AssociationManager
  def initialize(item)
    @item = item
    @klass = @item.class.name.constantize
  end

  def get_association_info
    return_hash = {}
    @klass.reflections.keys.map do |x|
      reflection = @klass.reflections[x]
      return_hash[x.to_s]= {
          macro: reflection.macro,
          klass: reflection.class_name,
          foreign_key: reflection.foreign_key,
          foreign_type: reflection.foreign_type,
          polymorphic: reflection.polymorphic?,
      }
    end
    return_hash
  end

  def self.determine_association(association_info)
    if association_info[:macro] == :belongs_to
      create_belongs_to_association(association_info[:klass])
    else
      create_has_manny_association
    end
  end

  def create_belongs_to_association(klass)
    <<-EOF
association :#{klass.downcase}, factory: :#{klass.downcase}
    EOF
  end
end
