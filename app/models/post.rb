class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :product_name, presence: true
  validates :genre, presence: true
  validates :price, presence: true
  validates :image, presence: true
  validates :reason_for_selection, presence: true
  validates :good_point, presence: true
  validates :bad_point, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  attachment :image

  enum genre: {
    :"マタニティ" => 0, :"ベビーウェア" => 1, :"ベビーカー" => 2,
    :"抱っこ紐" => 3, :"チャイルドシート" => 4, :"ベビー寝具" => 5, :"ベビー家具" => 6,
    :"おむつ" => 7, :"おしりふき" => 8, :"食事用品" => 9, :"食品/ミルク" => 10, :"授乳用品/哺乳瓶" => 11,
    :"ベビーケア用品" => 12, :"おもちゃ" => 13, :"絵本" => 14, :"その他" => 15,
  }
  enum price: {
    :"〜999円" => 0, :"1,000円台" => 1, :"2,000円台" => 2, :"3,000円台" => 3, :"4,000円台" => 4,
    :"5,000円台" => 5, :"6,000〜10,000円" => 6, :"10,001〜15,000円" => 7, :"15,001〜20,000円" => 8,
    :"20,001〜30,000円" => 9, :"30,001〜40,000円" => 10, :"40,001〜50,000円" => 11,
    :"50,001〜75,000円" => 12, :"75,001〜100,000円" => 13, :"100,001円以上" => 14, :"不明" => 15,
  }
end
