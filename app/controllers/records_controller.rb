class RecordsController < ApplicationController
  before_action :logged_in_user
  # before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    @keyword = search_params[:keyword]
    @records = current_user.records.search(@keyword).order(:publish_date)
  end

  def edit
    @record = Record.find_by(id: params[:id])
  end

  def new
    @book = current_user.records.new(type: Book)
    @paper = current_user.records.new(type: Paper)
    @compilation = current_user.records.new(type: Compilation)
  end

  def create_book
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:success] = "登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def create_paper
    @paper = Paper.new(paper_params)
    @paper.user_id = current_user.id
    if @paper.save
      flash[:success] = "登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def create_compilation
    @compilation = Compilation.new(compilation_params)
    @compilation.user_id = current_user.id
    if @compilation.save
      flash[:notice] = "登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      puts @compilation.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @record = Record.find_by(id: params[:id])
    if @record.update(record_params)
      flash[:success] = "書誌情報を更新しました"
      redirect_to records_path
    else
      flash.now[:denger] = "書誌情報の更新に失敗しました"
      puts @record.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record = Record.find_by(id: params[:id])
    @record.destroy
    flash[:success] ="書誌情報を削除しました"
    redirect_to records_path
  end

  def ensure_correct_user
    @record = Record.find_by(id: params[:id])
    if @record.user_id != current_user.id
      flash[:danger] = "権限がありません"
      redirect_to records_path
    end
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_url, status: :see_other
    end
  end

  private
  def record_params
    params.permit(
      :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
      :compiled_by, :publication_main_title, :publication_sub_title,
      :volume, :no, :volume_other_form, :memo, :status
    )
  end

  def book_params
    params.require(:book).permit(
      :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
      :volume_other_form, :memo, :status
    )
  end

  def paper_params
    params.require(:paper).permit(
      :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
      :compiled_by, :publication_main_title, :publication_sub_title,
      :volume, :no, :volume_other_form, :memo, :status
    )
  end

  def compilation_params
    params.require(:compilation).permit(
      :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
      :compiled_by, :publication_main_title, :publication_sub_title,
      :volume, :no, :volume_other_form, :memo, :status
    )
  end

  def search_params
    params.permit(:keyword)
  end
end
