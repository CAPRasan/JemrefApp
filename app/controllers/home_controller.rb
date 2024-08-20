class HomeController < ApplicationController
  before_action :authenticatie_user

  def top
    @record = Record.new
  end
end
