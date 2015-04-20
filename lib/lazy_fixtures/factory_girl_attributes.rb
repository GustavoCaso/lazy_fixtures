module LazyFixtures
  class FactoryGirlAttributes < LazyFixtures::AttributesManager
    def add_attributes
      return_value = ''
      attributes.each do |k,v|
        value =  ValueMapper.new(@object, k.to_s.dup, v).map_values
        key = ValueMapper.remove_encrypted(k.to_s.dup)
        return_value += "    #{key} #{value}\n"
      end
      return_value
    end
  end
end