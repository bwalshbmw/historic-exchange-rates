# Controller for rendering main application page and requests from there.
class ExchangeRatesController < ApplicationController
  after_action :set_currency_cookie, only: :index

  def index; end

  private

  def set_currency_cookie
    session[:currency] = params[:currency]
  end
end
