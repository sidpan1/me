module Api
  class PostsController < Api::ApiController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /api/posts
  # GET /api/posts.json
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /api/posts/1
  # GET /api/posts/1.json
  def show
  end

  # GET /api/posts/new
  def new
    @post = Post.new

    render json: @post
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.fetch(:post, {})
    end
  end
end
