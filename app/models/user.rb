class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followings, source: :follower
  attachment :profile_image

  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end
end
