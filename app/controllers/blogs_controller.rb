class BlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, only: [:edit, :update, :destroy]

  def index
    @blogs = Blog.all
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
    if @blog.save
      flash[:success] = "ブログを作成しました！"
      redirect_to blogs_path
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
end
