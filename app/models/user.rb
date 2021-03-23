class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  # 自分がフォローする側の関係性
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 自分がフォローされる側の関係性
  has_many :followings, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローしている人
  has_many :following_users, through: :followers, source: :followed
  # 自分をフォローしている人
  has_many :follower_users, through: :followings, source: :follower
  attachment :profile_image

  validates :name, presence: true
  validates :user_name, uniqueness: { message: 'は既に使用されており、登録できません' }, presence: true
  validates_format_of :phone_number, with:  /\A\d{10,11}\z/

  def self.guest
    find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.user_name = "ゲストユーザー"
      user.phone_number = "00000000000"
      user.confirmed_at = Time.now
    end
  end

  # 下の３項目はビューでフォローする/フォロー外すボタンの表示で使用
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
