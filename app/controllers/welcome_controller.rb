class WelcomeController < ApplicationController
  def index
    @posts = Post.published.limit(6)
  end
end
