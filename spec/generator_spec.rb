require 'spec_helper'

describe LazyFixtures::Generator do
  describe 'Generator' do
    context 'LazyFixtures::LazyFixtures::FactoryGirl' do
      before(:each) do
        @user = User.create(name: 'Gustavo', age: 26)
        @generator = LazyFixtures::Generator.new(@user, create: false)
      end

      it 'receive generate message' do
        expect_any_instance_of(LazyFixtures::FactoryGirl::FactoryGirl).to receive(:generate)
        @generator.generate('FactoryGirl')
      end
    end
  end
end
