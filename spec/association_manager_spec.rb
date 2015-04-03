require 'spec_helper'

describe FactoryGenerator::AssociationManager do

  before(:each) do
    @user = User.create(name:'Evaristo', age: 67)
    @post = Post.create(title:'Post title', post_body: 'This is not important', user_id: 3)
  end

  describe '#columns_info' do
    it 'will return hash with reflections information' do
      return_value = FactoryGenerator::AssociationManager.new(@user).columns_info
      expect(return_value).to eq({'posts' => {method: :posts, macro: :has_many, klass: 'Post'}})
    end

    it 'will return hash with reflections information' do
      return_value = FactoryGenerator::AssociationManager.new(@post).columns_info
      expect(return_value).to eq('user' => {method: :user, macro: :belongs_to, klass: 'User'})
    end
  end

  describe '#determine_association' do
    it 'will return text for belongs to association' do
      user_association_info = FactoryGenerator::AssociationManager.new(@post).columns_info['user']
      return_value = FactoryGenerator::AssociationManager.new(@post).determine_association(user_association_info, 'User', 'user')
      expect(return_value).to eq "    association :user, factory: :user\n"
    end

    it 'will return text for belongs to association with right association' do
      user_association_info = FactoryGenerator::AssociationManager.new(@post).columns_info['user']
      return_value = FactoryGenerator::AssociationManager.new(@post).determine_association(user_association_info, 'User', 'writter')
      expect(return_value).to eq "    association :writter, factory: :user\n"
    end

    it 'will return text for belongs to association with right factory' do
      user_association_info = FactoryGenerator::AssociationManager.new(@post).columns_info['user']
      return_value = FactoryGenerator::AssociationManager.new(@post).determine_association(user_association_info, 'Writter', 'user')
      expect(return_value).to eq "    association :user, factory: :writter\n"
    end


    it 'will return text for has_many to association' do
      post_association_info = FactoryGenerator::AssociationManager.new(@user).columns_info['posts']
      return_value = FactoryGenerator::AssociationManager.new(@user).determine_association(post_association_info, 'Post', 'post')
      expect(return_value).to eq "    after(:create) do |x|\n      create_list(:post, 1, user: x)\n    end\n"
    end
  end
end