module LazyFixtures
  module ObjectHelper
    def get_object(object)
      object.respond_to?('first') ? object.first : object
    end

    def invalid_object?(object)
      object.nil? || (object.respond_to?('first') && object.empty?)
    end
  end
end
