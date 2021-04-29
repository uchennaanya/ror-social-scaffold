require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user1) { User.create(name: 'user1', email: 'user1@hotmail.com', password: 'password') }
  let(:user2) { User.create(name: 'user2', email: 'user2@hotmail.com', password: 'password') }
  let(:new_friendship) { Friendship.create(user: user1, friend: user2) }
  let(:new_invalid_friendship) { Friendship.create(user: user1) }

  describe 'Friendships can be created' do
    it 'sets default value of false to confirmed' do
      expect(new_friendship.confirmed).to be false
    end

    it 'checks if friendship is valid' do
      expect(new_friendship).to be_valid
      expect(user1.friendships.size).to eq(1)
    end

    it 'checks if friendship is invalid' do
      expect(new_invalid_friendship.valid?).to be(false)
    end

    it 'checks if user have friends :)' do
      new_friendship.confirmed = true
      new_friendship.save
      expect(user1.friends.size).to eq(1)
    end

    it 'checks if user have no friends :(' do
      new_friendship.save
      expect(user1.friends.size).to eq(0)
    end

    it 'create inverse friendship once confirmed' do
      new_friendship.save
      new_friendship.confirmed = true
      new_friendship.save

      expect(Friendship.where(user: new_friendship.friend, friend: new_friendship.user)).not_to be_nil
    end
  end
end
