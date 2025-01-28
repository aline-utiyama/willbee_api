# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Test for the presence of email
  it 'is valid with a unique and valid email' do
    user = User.new(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(username: 'testuser', name: "test", surname: "user", password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid with a non-unique email' do
    User.create(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    user = User.new(email: 'test@example.com', name: "test", surname: "user", username: 'anotheruser', password: 'password123')
    expect(user).not_to be_valid
  end

  # Test for the presence of username
  it 'is valid with a unique and valid username' do
    user = User.new(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without a username' do
    user = User.new(email: 'test@example.com', name: "test", surname: "user", password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid with a non-unique username' do
    User.create(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    user = User.new(email: 'another@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user).not_to be_valid
  end

  # Test for password length
  it 'is invalid if the password is less than 6 characters' do
    user = User.new(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'short')
    expect(user).not_to be_valid
  end

  it 'is valid if the password is 6 characters or more' do
    user = User.new(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user).to be_valid
  end

  # Test for has_secure_password functionality
  it 'authenticates a user with the correct password' do
    user = User.create(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user.authenticate('password123')).to eq(user)
  end

  it 'does not authenticate a user with the incorrect password' do
    user = User.create(email: 'test@example.com', name: "test", surname: "user", username: 'testuser', password: 'password123')
    expect(user.authenticate('wrongpassword')).to be_falsey
  end
end
