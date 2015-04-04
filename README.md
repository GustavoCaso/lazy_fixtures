# FactoryGenerator
[![Build Status](https://travis-ci.org/GustavoCaso/factory_generator.svg?branch=master)](https://travis-ci.org/GustavoCaso/factory_generator)

Generator to create factory girl fixtures, just with a simple ActiveRecord object
from your current database.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_generator

## Usage

Inside your console simple type `FactoryGenerator.generate()` inside the parenthesis place an ActiveRecord object, and this command will generate the corresponding file inside your project.

## Initialisation

If you are using this gem inside a rails project you can use the initialise folder you can add a file to configure some attributes that will help the gem work properly.

```ruby
require 'factory_girl'

FactoryGirl.factories.clear
FactoryGirl.find_definitions

FactoryGenerator.configure do |config|
  config.factory_directory = "#{specify which folder are your fixtures save}"
  config.factory_names = FactoryGirl.factories.map(&:name)
end
```

This lines will tell the gem where to store the files and it will give them a list with your actual Factory Girl fixtures, with this it will avoid factory girl exceptions.

## Options

There are several options you can pass to the generator, the method will receive these options as a hash so the order is not redundant.

1. **nested** => by default is set to false, set this to true and will traverse all the associations from your object and will create does fixtures for you as well.
2. **overwrite** => by default is set to false, set this to true and will overwrite does file with same name inside the fixtures folder that you specify. If for some reason it find a file with the same name and the option is set to false it will ask you if you want to overwrite. That choice is up to you :-)
3. **create** => by default  is set to true, this options tell the generator to create the file, if is set to false it will not generate any file.
4. **skip_attr** => this accept an array of string which will remove those attributes from the object.
5. **change_attr** => this accepts a hash with new values for the fixture you want to set.

## Examples

###This will create a switch fixture:

`FactoryGenerator.generate(Switch.last)`

###This will create a switch fixture and traverse all the associations:

`FactoryGenerator.generate(Switch.last, nested: true)`

###This will create a switch fixture with skipped attributes:

`FactoryGenerator.generate(Switch.last, skip_attr:['age', 'name'])`

###This will create a switch fixture with custom values:

`FactoryGenerator.generate(Switch.last, change_attr:{'age' => 34, 'name' => 'John'})`

##Notes
This version is the first version, I want to add more functionality to it, skipping and changing nested attributes from the object, and many more.
If you use the gem I see any errors or some functionality that might be useful please let me know.
Thanks.


## Contributing

1. Fork it ( https://github.com/GustavoCaso/factory_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
