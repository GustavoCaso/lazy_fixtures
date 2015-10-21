require 'lazy_fixtures/version'
require 'lazy_fixtures/generator'
require 'lazy_fixtures/factory_girl/factory_girl'
require 'lazy_fixtures/factory_girl/association_manager'
require 'lazy_fixtures/factory_girl/file_manager'
require 'lazy_fixtures/factory_girl/value_mapper'
require 'lazy_fixtures/factory_girl/attributes_manager'

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
    LazyFixtures::Generator.new(object, options).generate('FactoryGirl')
  end
end
