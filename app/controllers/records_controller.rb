class RecordsController < ApplicationController
  before_action :authenticatie_user

  def index
  end

  def create
    @record = Record.new(
      user_id: @current_user,
      author_name: params[:author_name],
      main_title: params[:main_title],
      sub_title: params[:sub_title],
      publish_date: params[:publish_date],
      publisher: params[:publisher],
      compiled_by: params[:compiled_by],
      publication: params[:publication],
      volume: params[:volume],
      no: params[:no],
      memo: params[:memo],
      status: params[:status]
    )
    if @record.save
      flash[:notice] = "登録が成功しました"
      redirect_to("/")
    else
      puts "登録に失敗しました"
      puts @record.errors.full_messages
      render("home/top")
    end
  end
end
