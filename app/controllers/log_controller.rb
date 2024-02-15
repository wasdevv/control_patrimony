class LogController < ApplicationController
  def index
    @logs = Log.all
  end
end
