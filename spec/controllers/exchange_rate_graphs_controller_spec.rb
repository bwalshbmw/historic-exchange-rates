require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  describe 'GET index' do
    it 'should render the exchange rates index page' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
