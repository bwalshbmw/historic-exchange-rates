require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  describe 'GET index' do
    it 'should render the exchange rates index page' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'should set the currency for the session when the param is provided' do
      get :index, params: { currency: 'USD' }
      expect(session[:currency]).to eq 'USD'
    end

    it 'should not set the currency for the session when there is no param' do
      get :index
      expect(session[:currency]).to be_blank
    end
  end
end
