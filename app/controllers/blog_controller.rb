class BlogController < ApplicationController
  def index
    @posts = Post.published.paginate(:page => params[:page], :per_page => 6)
  end

  def show
    @post = Post.published.friendly.find(params[:id])
  end
end
