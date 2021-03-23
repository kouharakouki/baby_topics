require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe '投稿のテスト' do
    context '有益な投稿内容' do
      it "保存されること" do
        expect(FactoryBot.build(:post)).to be_valid
      end
    end
  end

  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'product_nameカラム' do
      it '空欄でないこと' do
        post.product_name = ''
        is_expected.to eq false
      end
    end

    context 'image_idカラム' do
      it '空欄でないこと' do
        post.image_id = ''
        is_expected.to eq false
      end
    end

    context 'genreカラム' do
      it '空欄でないこと' do
        post.genre = ''
        is_expected.to eq false
      end
    end

    context 'priceカラム' do
      it '空欄でないこと' do
        post.price = ''
        is_expected.to eq false
      end
    end

    context 'reason_for_selectionカラム' do
      it '空欄でないこと' do
        post.reason_for_selection = ''
        is_expected.to eq false
      end
    end

    context 'good_pointカラム' do
      it '空欄でないこと' do
        post.good_point = ''
        is_expected.to eq false
      end
    end

    context 'bad_pointカラム' do
      it '空欄でないこと' do
        post.bad_point = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Post_commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end

    context 'favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Bookmarkモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:bookmarks).macro).to eq :has_many
      end
    end
  end
end
