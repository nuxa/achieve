class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :sending_pusher, only: [:create]
  before_action :set_comment, only: [:destroy]
  # コメントを保存、投稿するためのアクション
  def create
    # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを私用する。
    @comment = current_user.comments.build(comment_params)
    @blog = @comment.blog
    @notification = @comment.notifications.build(recipient_id: @blog.user_id, sender_id: current_user.id)
    binding.pry
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました。'}
        format.json { render :show, status: :created, location: @comment }
        # JS形式でレスポンスを返す
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to blog_path(@blog), notice: 'コメントを削除しました。'}
        format.json { render :show, status: :deletd, location: @comment }
        # JS形式でレスポンスを返す
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end


  end

  private
    def comment_params
      params.require(:comment).permit(:blog_id, :user_id, :content)
    end

    def set_comment
      @comment = Comment.find(params[:id])
      @blog = @comment.blog
    end

    def sending_pusher
      Notification.sending_pusher(@notification.recipient_id)
    end
end
