class BlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, only: [:edit, :update, :destroy, :show]
  before_action :permit_user, only: [:destroy, :update]

  def index
    @blogs = Blog.all.order(updated_at: :desc)
  end

  # showアクションを定義します。入力フォームと一覧を表示するためインスタンスを２つ生成します。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
  end

  def new
    if params[:back]
      @blog = Blog.new(blogs_params)
    else
      @blog = Blog.new
    end
  end

  def create
    @blog = Blog.new(blogs_params)
    @blog.user_id = current_user.id
    if @blog.save
      flash[:success] = "ブログを作成しました！"
      redirect_to blogs_path
      NoticeMailer.sendmail_blog(@blog).deliver
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    @blog.update(blogs_params)
    if @blog.invalid?
      render action: 'edit'
    else
      flash[:success] = "ブログを更新しました！"
      redirect_to blogs_path
    end
  end

  def destroy
    @blog.destroy
    flash[:success] = "ブログを削除しました！"
    redirect_to blogs_path
  end

  def confirm
    @blog = Blog.new(blogs_params)
    render 'new' if @blog.invalid?
  end

  private
    def blogs_params
      params.require(:blog).permit(:title, :content)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    end

    def permit_user
      redirect_to blogs_path unless current_user.id == @blog.user.id || current_user.admin?
    end
end
