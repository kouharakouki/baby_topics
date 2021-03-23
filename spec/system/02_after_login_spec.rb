require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の投稿画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post.user)
        expect(page).to have_link '', href: post_path(other_post.user)
      end
      it '自分と他人のユーザー名のリンク先がそれぞれ正しい' do
        expect(page).to have_link post.user.user_name, href: user_path(post.user)
        expect(page).to have_link other_post.user.user_name, href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿のジャンル名が表示される' do
        expect(page).to have_content post.genre
        expect(page).to have_content other_post.genre
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '「投稿詳細画面」と表示される' do
        expect(page).to have_content '投稿詳細画面'
      end
      it 'ユーザー画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.user_name, href: user_path(post.user)
      end
      it '投稿のジャンル名が表示される' do
        expect(page).to have_content post.genre
      end
      it '投稿の商品名が表示される' do
        expect(page).to have_content post.product_name
      end
      it '投稿の価格帯が表示される' do
        expect(page).to have_content post.price
      end
      it '投稿の商品を選んだ理由が表示される' do
        expect(page).to have_content post.reason_for_selection
      end
      it '投稿の商品メリットが表示される' do
        expect(page).to have_content post.good_point
      end
      it '投稿の商品デメリットが表示される' do
        expect(page).to have_content post.bad_point
      end
      it '投稿の商品の補足情報が表示される' do
        expect(page).to have_content post.free_text
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集する', href: edit_post_path(post)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集する'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「投稿編集フォーム」と表示される' do
        expect(page).to have_content '投稿編集フォーム'
      end
      it 'ジャンル編集フォームが表示される' do
        expect(page).to have_field 'post[genre]', with: post.genre
      end
      it '商品名編集フォームが表示される' do
        expect(page).to have_field 'post[product_name]', with: post.product_name
      end
      it '商品価格帯編集フォームが表示される' do
        expect(page).to have_field 'post[price]', with: post.price
      end
      it '商品を選んだ理由編集フォームが表示される' do
        expect(page).to have_field 'post[reason_for_selection]', with: post.reason_for_selection
      end
      it '商品のメリット編集フォームが表示される' do
        expect(page).to have_field 'post[good_point]', with: post.good_point
      end
      it '商品のデメリット編集フォームが表示される' do
        expect(page).to have_field 'post[bad_point]', with: post.bad_point
      end
      it '商品の補足情報編集フォームが表示される' do
        expect(page).to have_field 'post[free_text]', with: post.free_text
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
      it '詳細画面に戻るリンクが表示される' do
        expect(page).to have_link '詳細画面に戻る', href: post_path(post)
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '投稿を削除する'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_genre = post.genre
        @post_old_product_name = post.product_name
        @post_old_price = post.price
        @post_old_reason_for_selection = post.reason_for_selection
        @post_old_good_point = post.good_point
        @post_old_bad_point = post.bad_point
        @post_old_free_text = post.free_text
        select '絵本', from: 'post[genre]'
        fill_in 'post[product_name]', with: Faker::Lorem.characters(number: 10)
        select '1,000円台', from: 'post[price]'
        fill_in 'post[reason_for_selection]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[good_point]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[bad_point]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[free_text]', with: Faker::Lorem.characters(number: 10)
        click_button '変更内容を保存する'
      end

      it '商品名が正しく更新される' do
        expect(post.reload.genre).not_to eq @post_old_genre
      end
      it '商品名が正しく更新される' do
        expect(post.reload.product_name).not_to eq @post_old_product_name
      end
      it '商品を選んだ理由が正しく更新される' do
        expect(post.reload.reason_for_selection).not_to eq @post_old_reason_for_selection
      end
      it '商品のメリットが正しく更新される' do
        expect(post.reload.good_point).not_to eq @post_old_good_point
      end
      it '商品のデメリットが正しく更新される' do
        expect(post.reload.bad_point).not_to eq @post_old_bad_point
      end
      it '商品の補足情報が正しく更新される' do
        expect(post.reload.free_text).not_to eq @post_old_free_text
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
        expect(page).to have_content '投稿詳細画面'
      end
    end
  end

  describe 'アカウント一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.user_name
        expect(page).to have_content other_user.user_name
      end
      it '自分と他人の詳細画面へのリンクがそれぞれ表示される' do
        expect(page).to have_link '', href: user_path(user)
        expect(page).to have_link '', href: user_path(other_user)
      end
    end
  end

  describe '自分のアカウント詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.user_name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '自分のbブックマーク一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: users_bookmark_path(user)
      end
      it '投稿一覧の商品画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post)
      end
      it '投稿一覧に自分の投稿のジャンルが表示される' do
        expect(page).to have_content post.genre
      end
      it '投稿一覧に自分の投稿のが商品名が表示される' do
        expect(page).to have_content post.product_name
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.product_name
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it 'ユーザーネーム編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[user_name]', with: user.user_name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '自己紹介編集フォームに自分の電話番号が表示される' do
        expect(page).to have_field 'user[phone_number]', with: user.phone_number
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_user_name = user.user_name
        @user_old_intrpduction = user.introduction
        @user_old_phone_number = user.phone_number
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[user_name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        fill_in 'user[phone_number]', with: Faker::Number.number(digits: Faker::Number.between(from: 10, to: 11))
        click_button '変更内容を保存する'
      end

      it '名前が正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'ユーザーネームが正しく更新される' do
        expect(user.reload.user_name).not_to eq @user_old_user_name
      end
      it '自己紹介が正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it '電話番号が正しく更新される' do
        expect(user.reload.phone_number).not_to eq @user_old_phone_number
      end
      it 'リダイレクト先が、自分のアカウント詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end
