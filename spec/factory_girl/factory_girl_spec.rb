require 'spec_helper'

describe LazyFixtures::FactoryGirl::FactoryGirl do
  let(:user) { User.create(name:'Evaristo', age: 67)}
  let(:post) { Post.create(title:'Post title', post_body: 'This is not important', user_id: user.id) }

  context 'Create FactoryGirl File' do
    xit 'write the specific file' do
      LazyFixtures::Generator.new(post, {create: false}).generate('FactoryGirl')

      expect(File.exist?("#{LazyFixtures.configuration.factory_directory}/post.rb"))
    end
  end
end
