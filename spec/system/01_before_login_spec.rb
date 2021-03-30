require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it '新規登録リンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[2].native.inner_text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[2].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/ログイン/i)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'ベビトピについてと便利な使い方を押すと、about画面に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.delete(' ')
        about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[2].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'loginを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[3].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
      it 'お問い合わせを押すと、お問い合わせ画面に遷移する' do
        contact_link = find_all('a')[4].native.inner_text
        contact_link = contact_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link contact_link
        is_expected.to eq '/contacts/new'
      end
      it 'ゲストログインを押すと、投稿一覧画面に遷移する' do
        guest_login_link = find_all('a')[5].native.inner_text
        guest_login_link = guest_login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link guest_login_link
        is_expected.to eq '/posts'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規アカウントを作成」と表示される' do
        expect(page).to have_content '新規アカウントを作成'
      end
      it 'フルネームフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'ユーザーネームフォームが表示される' do
        expect(page).to have_field 'user[user_name]'
      end
      it '電話番号フォームが表示される' do
        expect(page).to have_field 'user[phone_number]'
      end
      it 'Eメールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード確認フォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'アカウント登録ボタンが表示される' do
        expect(page).to have_button 'アカウント登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[user_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[phone_number]', with: '00012345678'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'アカウント登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、トップページになっている' do
        click_button 'アカウント登録'
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン画面」と表示される' do
        expect(page).to have_content 'ログイン画面'
      end
      it 'Eメールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'アバウトリンクが表示される: 左上から1番目のリンクが「ベビトピについてと便利な使い方」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/ベビトピについてと便利な使い方/i)
      end
      it 'マイページリンクが表示される: 左上から2番目のリンクが「マイページ」である' do
        my_page_link = find_all('a')[2].native.inner_text
        expect(my_page_link).to match(/マイページ/i)
      end
      it 'アカウント一覧リンクが表示される: 左上から3番目のリンクが「アカウント一覧」である' do
        users_link = find_all('a')[3].native.inner_text
        expect(users_link).to match(/アカウント一覧/i)
      end
      it '投稿一覧リンクが表示される: 左上から4番目のリンクが「投稿一覧」である' do
        posts_link = find_all('a')[4].native.inner_text
        expect(posts_link).to match(/投稿一覧/i)
      end
      it '新規投稿リンクが表示される: 左上から5番目のリンクが「新規投稿」である' do
        new_post_link = find_all('a')[5].native.inner_text
        expect(new_post_link).to match(/新規投稿/i)
      end
      it 'ログアウトリンクが表示される: 左上から6番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/ログアウト/i)
      end
      it 'お問い合わせリンクが表示される: 左上から7番目のリンクが「お問い合わせ」である' do
        contact_link = find_all('a')[7].native.inner_text
        expect(contact_link).to match(/お問い合わせ/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'ベビトピについてと便利な使い方を押すと、ベビトピについてと便利な使い方に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it 'マイページを押すと、マイページに遷移する' do
        my_page_link = find_all('a')[2].native.inner_text
        my_page_link = my_page_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link my_page_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'アカウント一覧を押すと、アカウント一覧に遷移する' do
        users_link = find_all('a')[3].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it '投稿一覧を押すと、投稿一覧に遷移する' do
        posts_link = find_all('a')[4].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it '新規投稿を押すと、新規投稿に遷移する' do
        new_post_link = find_all('a')[5].native.inner_text
        new_post_link = new_post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link new_post_link, match: :first
        is_expected.to eq '/posts/new'
      end
      it 'お問い合わせを押すと、お問い合わせに遷移する' do
        contact_link = find_all('a')[7].native.inner_text
        contact_link = contact_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link contact_link
        is_expected.to eq '/contacts/new'
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[6].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
