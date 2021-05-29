class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: :friend_id

  has_many :confirmed_friendships, -> { where status: 'accept' }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  has_many :sent_requests, class_name: 'Friendship', dependent: :destroy, foreign_key: :user_id
  has_many :received_requests, class_name: 'Friendship', dependent: :destroy, foreign_key: :friend_id

  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  def friends_and_own_posts
    Post.where(user: (friends.to_a << self))
  end

  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = friend_requests.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def reject_friend(user)
    friendship = friend_requests.find { |f| f.user == user }
    friendship.destroy
  end

  def friend?(user)
    friends.include?(user)
  end
end
