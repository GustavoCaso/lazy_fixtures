require 'factory_generator/version'
require 'factory_generator/generator'
require 'factory_generator/association_manager'
require 'factory_generator/file_manager'
require 'factory_generator/value_mapper'

module FactoryGenerator
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
    FactoryGenerator::Generator.new(object, options).generate
  end
end
