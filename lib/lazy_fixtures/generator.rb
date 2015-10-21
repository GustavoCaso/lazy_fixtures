require 'lazy_fixtures/object_helper'

module LazyFixtures
  class Generator
    include LazyFixtures::ObjectHelper
    attr_reader :options, :object

    DEFAULT_OPTIONS = {
        nested:      false,
        overwrite:   false,
        create:      true,
        parent:      [],
        skip_attr:   [],
        change_attr: {}
    }

    def initialize(object, options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @object = get_object(object)
    end

    def generate(type)
      gather_class(type).new(object, options).generate
    end

    private

    def gather_class(type)
      "LazyFixtures::#{type}::#{type}".constantize
    end
  end
end
