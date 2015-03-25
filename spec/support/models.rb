class User < ActiveRecord::Base
  before_save :create_timestamps

  def create_timestamps
    self.created_at = DateTime.new(1986,9,29)
    self.updated_at = DateTime.new(1986,9,29)
  end
end