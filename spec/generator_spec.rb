require 'spec_helper'

describe FactoryGenerator::Generator do

  before(:each) do
    FactoryGenerator::Configuration.new
  end

  it 'it will create factory body' do
    user = User.create(name: 'Gustavo', age: 26)
    text = <<-EOF
    id 1
    name 'Gustavo'
    age 26
    created_at '1986-09-29T00:00:00+00:00'
    updated_at '1986-09-29T00:00:00+00:00'
    EOF
    expect(FactoryGenerator::Generator.new(user, create: false).generate).to eq text
  end
end