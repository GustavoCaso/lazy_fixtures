require 'spec_helper'

describe LazyFixtures::FactoryGirl::AttributesManager do

  let(:default_options) { LazyFixtures::Generator::DEFAULT_OPTIONS }

  it 'will return hash with attributes' do
    user = User.create(name: 'Caita', age: 57)
    attributes_manager = described_class.new(user, default_options)
    expect_return = {'id' => user.id, 'name' => user.name,
                     'age' => user.age, 'created_at' => user.created_at,
                     'updated_at' => user.updated_at}
    expect(attributes_manager.each).to eq expect_return
  end

  it 'will return string with all the value from the object' do
    user = User.create(name: 'Caita', age: 57)
    attributes_manager = described_class.new(user, default_options)
    expected_attributes = "    id #{user.id}\n    name 'Caita'\n    age 57\n    created_at '1986-09-29T00:00:00+00:00'\n    updated_at '1986-09-29T00:00:00+00:00'\n"
    expect(attributes_manager.stringify_attributes).to eq expected_attributes
  end

  it 'will return string with all value from the object removing the encrypted part' do
    user = UserWithEncrypted.create(name: 'Eduardo', age: 60,
                                    encrypted_password: 'retvbhj')
    attributes_manager = described_class.new(user, default_options)
    expected_attributes = "    id #{user.id}\n    name 'Eduardo'\n    age 60\n    password 'retvbhj'\n"
    expect(attributes_manager.stringify_attributes).to eq expected_attributes
  end

  it 'will skip attributes from the options hash' do
    user = User.create(name: 'Caita', age: 57)
    options = default_options.merge({skip_attr: ['age']})
    attributes_manager = described_class.new(user, options)
    expected_attributes = {'id' => user.id, 'name' => user.name,
                           'created_at' => user.created_at,
                           'updated_at' => user.updated_at}
    expect(attributes_manager.each).to eq expected_attributes
  end

  it 'will modify attributes value from the options hash' do
    user = User.create(name: 'Caita', age: 57)
    options = default_options.merge({change_attr: {'age' => 109}})
    attributes_manager = described_class.new(user, options)
    expected_attributes = {'id' => user.id, 'name' => user.name,
                           'age' => 109, 'created_at' => user.created_at,
                           'updated_at' => user.updated_at}
    expect(attributes_manager.each).to eq expected_attributes
  end

  it 'will remove attributes from association which are not nill' do
    user = User.create(name: 'Caita', age: 57)
    post = Post.create(title:'Post title', post_body: 'This is not important', user_id: user.id)
    options = default_options
    attributes_manager = described_class.new(post, options)
    expected_attributes = {'id' => post.id, 'title' => post.title,
                           'post_body' => post.post_body}
    expect(attributes_manager.delete_association_attributes('user')).to eq expected_attributes
  end
end
