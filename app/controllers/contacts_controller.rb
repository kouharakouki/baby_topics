class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  # 入力内容確認画面。newアクションから入力内容を受け取り、
  # 送信ボタンを押されたらcreateアクションを実行
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      render :new
    end
  end

  # 確認画面から一度new画面に戻り、ブラウザの進むボタンを押された際
  # getメソッドが働き、postメソッドで表示する確認画面がエラーになるため
  def error
    redirect_to new_contact_path
  end

  # 確認画面から送信ボタンを押してここで保存
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to root_path, notice: "お問い合わせ内容を送信しました。"
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :phone_number, :message)
  end
end
