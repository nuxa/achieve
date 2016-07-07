class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.create(blogs_params)
    redirect_to blogs_path
  end

  private
    def blogs_params
      params.require(:blog).permit(:title, :content)
    end
end
