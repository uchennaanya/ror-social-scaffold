class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: :friend_id

  has_many :confirmed_friendships, -> { where status: 'accept' }, class_name: "Friendship"
  has_many :friends, through: :confirmed_friendships

  has_many :sent_requests, class_name: 'Friendship', dependent: :destroy, foreign_key: :user_id
  has_many :received_requests, class_name: 'Friendship', dependent: :destroy, foreign_key: :friend_id
end
