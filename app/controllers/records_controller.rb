class RecordsController < ApplicationController
  before_action :authenticatie_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    @keyword = search_params[:keyword]
    @records = @current_user.records.search(@keyword).order(:publish_date)
  end

  def edit
    @record = Record.find_by(id: params[:id])
  end

  def new
    @book = Book.new
    @paper = Paper.new
    @compilation = Compilation.new
  end

  def create_book
    @book = Book.new(books_params)
    @book.user_id = @current_user.id
    if @book.save
      flash[:notice] = "登録に成功しました"
      redirect_to("/records/new")
    else
      # デバッグ用
      puts "登録に失敗しました"
      puts @book.errors.full_messages
      # render用に空のインスタンスを作成
      @paper = Paper.new
      @compilation = Compilation.new
      render :new, status: :unprocessable_entity
    end
  end

  def create_paper
    @paper = Paper.new(papers_params)
    @paper.user_id = @current_user.id
    if @paper.save
      flash[:notice] = "登録に成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @paper.errors.full_messages
      @book = Book.new
      @compilation = Compilation.new
      render :new, status: :unprocessable_entity
    end
  end

  def create_compilation
    @compilation = Compilation.new(compilation_params)
    @compilation.user_id = @current_user.id
    if @compilation.save
      flash[:notice] = "登録に成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @compilation.errors.full_messages
      @book = Book.new
      @paper = Paper. new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @record = Record.find_by(id: params[:id])
    if @record.update(record_params)
      flash[:notice] = "書誌情報を更新しました"
      redirect_to("/records/index")
    else
      flash[:notice] = "書誌情報の更新に失敗しました"
      puts @record.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record = Record.find_by(id: params[:id])
    @record.destroy
    flash[:notice] ="書誌情報を削除しました"
    redirect_to("/records/index")
  end

  def ensure_correct_user
    @record = Record.find_by(id: params[:id])
    if @record.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/records/index")
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

  def books_params
    params.require(:book).permit(
      :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
      :compiled_by, :publication_main_title, :publication_sub_title,
      :volume, :no, :volume_other_form, :memo, :status
    )
  end

  def papers_params
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
