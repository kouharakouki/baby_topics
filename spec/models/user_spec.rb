require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe '新規登録のテスト' do
    context '有益な登録内容' do
      it "保存されること" do
        expect(FactoryBot.build(:user)).to be_valid
      end
    end
  end

  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
    end

    context 'user_nameカラム' do
      it '空欄でないこと' do
        user.user_name = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        user.user_name = other_user.user_name
        is_expected.to eq false
      end
    end

    context 'phone_numberカラム' do
      it '空欄でないこと' do
        user.phone_number = ''
        is_expected.to eq false
      end
      it '10桁以上であること: 9桁は×' do
        user.phone_number = Faker::Number.number(digits:9)
        is_expected.to eq false
      end
      it '10桁以上であること: 10~11桁は〇' do
        user.phone_number = Faker::Number.number(digits: Faker::Number.between(from: 10, to: 11))
        is_expected.to eq true
      end
      it '11桁以下であること: 12桁は×' do
        user.phone_number = Faker::Number.number(digits:12)
        is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end

    context 'passwordカラム' do
      it '空欄でないこと' do
        user.password = ''
        is_expected.to eq false
      end
      it '6桁以上であること: 5桁は×' do
        user.password = Faker::Lorem.characters(number: 5)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Post_commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'Bookmarkモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:bookmarks).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:followers).macro).to eq :has_many
      end
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:followings).macro).to eq :has_many
      end
    end
  end
end
