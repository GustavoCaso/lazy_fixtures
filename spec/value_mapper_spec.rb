require 'spec_helper'

describe LazyFixtures::ValueMapper do
  describe '#map_values' do
    before(:each) do
      @user = User.create(name: 'Gustavo', age: 26)
      allow(@user).to receive(:columns_hash).and_return({})
    end

    it 'return correct value format for integer' do
      allow({}).to receive(:type).and_return(:integer)
      value = LazyFixtures::ValueMapper.new(@user, 'id', 6).map_values
      expect(value).to eq 6
    end

    it 'return correct format for datetime' do
      allow({}).to receive(:type).and_return(:datetime)
      value = LazyFixtures::ValueMapper.new(@user, 'created_at', '1986-09-29T00:00:00+00:00').map_values
      expect(value).to eq "'1986-09-29T00:00:00+00:00'"
    end

    it 'return correct format for string' do
      allow({}).to receive(:type).and_return(:string)
      value = LazyFixtures::ValueMapper.new(@user, 'name', 'Gustavo').map_values
      expect(value).to eq "'Gustavo'"
    end

    it 'return correct format for float' do
      allow({}).to receive(:type).and_return(:float)
      value = LazyFixtures::ValueMapper.new(@user, 'id', 1.5).map_values
      expect(value).to eq 1.5
    end

    it 'return correct format for nil' do
      allow({}).to receive(:type).and_return(:string)
      value = LazyFixtures::ValueMapper.new(@user, 'name', nil).map_values
      expect(value).to eq "nil"
    end
  end

  describe '#remove_encrypted_attributes' do
    it 'return non encrypted values' do
      dummy = Struct.new('User', :encrypted_name, :age, :name)
      test_user = dummy.new('dueucvwuevcbwbcw', 23, 'gustavo')
      value = LazyFixtures::ValueMapper.new(test_user, 'encrypted_name', 'dueucvwuevcbwbcw').remove_encrypted_attributes
      expect(value).to eq 'gustavo'
    end
  end

  describe 'self#remove_encrypted' do
    it 'return key without encrypted in it' do
      key = 'encrypted_password'
      return_value = LazyFixtures::ValueMapper.remove_encrypted(key)
      expect(return_value).to eq 'password'
    end
  end

end