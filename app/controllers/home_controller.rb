class HomeController < ApplicationController
  def show
    @user = session[:cas]
  end
end
