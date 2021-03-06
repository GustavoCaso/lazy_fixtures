ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.integer :age
    t.timestamps
  end

  create_table :posts, force: true do |t|
    t.string :title
    t.string :post_body
    t.integer :user_id
  end

  create_table :user_with_encrypteds, force: true do |t|
    t.string :name
    t.integer :age
    t.string :encrypted_password
  end
end