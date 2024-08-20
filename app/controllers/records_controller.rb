class RecordsController < ApplicationController
  before_action :authenticatie_user

  def index
  end

  def edit
    @record = Record.find_by(id: params[:id])
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
      flash[:notice] = "更新が成功しました"
      redirect_to("/")
    else
      puts "更新に失敗しました"
      puts @record.errors.full_messages
      render("/")
    end
  end

  def update
    @record = Record.find_by(id: params[:id])
    @record.author_name = params[:author_name]
    @record.main_title = params[:main_title]
    @record.sub_title = params[:sub_title]
    @record.publish_date = params[:publish_date]
    @record.publisher = params[:publisher]
    @record.compiled_by = params[:compiled_by]
    @record.publication = params[:publication]
    @record.volume = params[:volume]
    @record.no = params[:no]
    @record.memo = params[:memo]
    @record.status = params[:status]

    if @record.save
      flash[:notice] = "更新に成功しました"
      redirect_to("/records/index")
    else
      flash[:notice] = "更新に失敗しました"
      redirect_to("/records/#{@record.id}/edit")
    end
  end
end
