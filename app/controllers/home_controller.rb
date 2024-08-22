class HomeController < ApplicationController
  def top
    @record = Record.new
  end
end
