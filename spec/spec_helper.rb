require 'active_record'
require 'factory_generator'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
load File.dirname(__FILE__) + '/support/schema.rb'
require File.dirname(__FILE__) +'/support/models'

FactoryGenerator.configure do |config|
  config.factory_directory = '.'
  config.factory_names = []
end

RSpec.configure do |config|
  config.before(:each) do
    User.destroy_all
  end

  config.after(:each) do
    User.destroy_all
  end
end