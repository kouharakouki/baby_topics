class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  attachment :image
  enum genre: [:"マタニティ", :"ベビーウェア", :"ベビーカー", :"抱っこ紐", :"チャイルドシート", :"ベビー寝具", :"ベビー家具", :"おむつ", :"おしりふき", :"食事用品", :"食品/ミルク", :"授乳用品/哺乳瓶", :"ベビーケア用品", :"おもちゃ", :"絵本", :"その他"]
  enum price: [:"〜999円", :"1,000円台", :"2,000円台", :"3,000円台", :"4,000円台", :"5,000円台", :"6,000〜10,000円", :"10,001〜15,000円", :"15,001〜20,000円", :"20,001〜30,000円", :"30,001〜40,000円", :"40,001〜50,000円", :"50,001〜75,000円", :"75,001〜100,000円", :"100,001円以上", :"不明"]
end
