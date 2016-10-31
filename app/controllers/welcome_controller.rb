class WelcomeController < ApplicationController
  def index
    @posts = Post.limit(6)
  end
end
