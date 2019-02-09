require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  describe 'GET historic rates' do
    it 'should get the historic rates for the chart' do
      get :historic_rates, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
