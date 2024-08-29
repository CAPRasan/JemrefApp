class HomeController < ApplicationController
  before_action :fobid_login_user
  def top
    @record = Record.new
  end
end
