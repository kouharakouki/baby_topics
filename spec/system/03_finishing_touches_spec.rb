require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'アカウント一覧画面' do
      visit users_path
      is_expected.to eq '/users/sign_in'
    end
    it 'アカウント詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'アカウント情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ブックマーク一覧画面' do
      visit users_bookmark_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'フォロー一覧画面' do
      visit user_followings_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'フォロワー一覧画面' do
      visit user_followers_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿一覧画面' do
      visit posts_path
      is_expected.to eq '/users/sign_in'
    end
    it '新規投稿画面' do
      visit new_post_path
      is_expected.to eq '/users/sign_in'
    end
    it '投稿詳細画面' do
      visit post_path(post)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿編集画面' do
      visit edit_post_path(post)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit post_path(other_post)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + other_post.id.to_s
        end
        it '「投稿詳細画面」と表示される' do
          expect(page).to have_content '投稿詳細画面'
        end
        it 'ユーザー画像・ユーザー名のリンク先が正しい' do
          expect(page).to have_link other_post.user.user_name, href: user_path(other_post.user)
        end
        it '投稿のジャンル名が表示される' do
          expect(page).to have_content other_post.genre
        end
        it '投稿の商品名が表示される' do
          expect(page).to have_content other_post.product_name
        end
        it '投稿の価格帯が表示される' do
          expect(page).to have_content other_post.price
        end
        it '投稿の商品を選んだ理由が表示される' do
          expect(page).to have_content other_post.reason_for_selection
        end
        it '投稿の商品メリットが表示される' do
          expect(page).to have_content other_post.good_point
        end
        it '投稿の商品デメリットが表示される' do
          expect(page).to have_content other_post.bad_point
        end
        it '投稿の補足情報が表示される' do
          expect(page).to have_content other_post.free_text
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_link '編集する'
        end
      end

      context '他人の投稿編集画面' do
        it '遷移できず、投稿一覧画面にリダイレクトされる' do
          visit edit_post_path(other_post)
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end

    describe '他人のユーザー詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '投稿一覧のユーザー画像のリンク先が正しい' do
          expect(page).to have_link '', href: user_path(other_user)
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_content post.product_name
        end
      end

      context '他人のユーザー情報編集画面' do
        it '遷移できず、自分のユーザー詳細画面にリダイレクトされる' do
          visit edit_user_path(other_user)
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end
  end
end
