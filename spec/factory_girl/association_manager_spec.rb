require 'spec_helper'

describe LazyFixtures::FactoryGirl::AssociationManager do

  before(:each) do
    @user = User.create(name:'Evaristo', age: 67)
    @post = Post.create(title:'Post title', post_body: 'This is not important', user_id: @user.id)
  end

  context '#get_associations' do
    it 'return a array of associations' do
      associations = described_class.new(@post).get_associations
      expect(associations).to eq([@user])
    end
  end
end
