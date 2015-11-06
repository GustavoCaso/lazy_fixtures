module LazyFixtures
  module FactoryGirl
    class AttributesManager

      attr_accessor :attributes
      attr_reader :options, :object

      def initialize(object, options={})
        @object = object
        @attributes = @object.attributes
        @options    = options
        manipulate_attributes
      end

      def each
        attributes
      end

      def stringify_attributes
        attributes.map do |k,v|
          value =  ValueMapper.new(object, k.to_s.dup, v).get_value
          key = ValueMapper.remove_encrypted(k.to_s.dup)
          "    #{key} #{value}\n"
        end.join
      end

      def delete_association_attributes
        attributes.delete_if {|k,v| k =~ Regexp.new(/.+_id/) && !v.nil?}
      end

      private

      def manipulate_attributes
        options[:skip_attr].each { |x|  attributes.delete(x)} if options[:skip_attr].any?
        attributes.merge!(options[:change_attr]) if options[:change_attr].any?
        delete_association_attributes
      end
    end
  end
end
