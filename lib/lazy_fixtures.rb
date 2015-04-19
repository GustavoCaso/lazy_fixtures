require 'lazy_fixtures/version'
require 'lazy_fixtures/generator'
require 'lazy_fixtures/association_manager'
require 'lazy_fixtures/file_manager'
require 'lazy_fixtures/value_mapper'
require 'lazy_fixtures/attributes_manager'
require 'lazy_fixtures/factory_girl_association'
require 'lazy_fixtures/factory_girl_attributes'
require 'lazy_fixtures/factory_girl_file'
require 'lazy_fixtures/fixture_association'
require 'lazy_fixtures/fixture_attributes'
require 'lazy_fixtures/fixture_file'
require 'lazy_fixtures/factory_girl_generator'
require 'lazy_fixtures/fixture_generator'

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
    if options[:type] == 'fixture'
      LazyFixtures::FixtureGenerator.new(object, options).generate
    elsif options[:type] == 'factory_girl'
      LazyFixtures::FactoryGirlGenerator.new(object, options).generate
    else
      raise "Invalid type specified #{options[:type]}"
    end
  end
end
