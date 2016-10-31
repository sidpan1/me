class BlogController < ApplicationController
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 6)
  end
end
