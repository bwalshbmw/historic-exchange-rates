# Default class which all controllers will inherit from in the app.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
