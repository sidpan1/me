module Admin
  class AdminController < ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    http_basic_authenticate_with name: "sid", password: "allowme"

    # force_ssl if: :ssl_allowed?
    #
    # def ssl_allowed?
    #   Rails.env.production?
    # end
  end
end

