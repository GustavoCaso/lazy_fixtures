require 'lazy_fixtures/version'
require 'lazy_fixtures/generator'
require 'lazy_fixtures/association_manager'
require 'lazy_fixtures/file_manager'
require 'lazy_fixtures/value_mapper'
require 'lazy_fixtures/attributes_manager'

module LazyFixtures
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :factory_directory, :factory_names

    def initialize
      @factory_directory = ''
      @factory_names = []
    end
  end

  def self.generate(object, options = {})
    LazyFixtures::Generator.new(object, options).generate
  end
end
