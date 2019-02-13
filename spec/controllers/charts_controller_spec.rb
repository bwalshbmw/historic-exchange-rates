require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  describe 'GET historic rates' do
    it 'should call the RateGetterService' do
      sample_data = { name: 'USD', data: { '2019-01-01': 0.3900000 } }
      expect(RateGetterService)
        .to receive(:get_rates).with(any_args) { sample_data }
      get :historic_rates
    end

    it 'should send the rates to the chart without error' do
      get :historic_rates
      expect(response).to have_http_status(:ok)
    end
  end
end
